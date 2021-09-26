import React, { useContext, useEffect, useState } from 'react'
import propTypes from 'prop-types'
import UserInfoMini from './UserInfoMini'
import { GlobalContext } from '../context/GlobalState'
import axios from 'axios'
import ModalPrivacidad from './Modales/ModalPrivacidad'
import ModalConfirmar from './Modales/ModalConfirmar'
import BtnsLike from './BtnsLike'

const Publicacion = ({
    titulo, 
    fecha, 
    contenido,
    nombreUsuario, 
    tipo, 
    likes, 
    dislikes,
    idUsuario = null,
    idPublicacion = null,
    conlike = false,
    condislike = false,
    recargar = () => {}
}) => {

    const { usuario, tipoUsuario } = useContext(GlobalContext)

    const [privacidad, setPrivacidad] = useState({
        publico : false,
        estudiante : false,
        profesor : false,
        directivo :false,
        load: false
    })
    const [datos, setDatos] = useState({
        titulo: titulo,
        contenido: contenido
    });

    const [cargando,setCargando] = useState(false)
    const [enviar, setEnviar] = useState(false)
    const [editando, setEditando] = useState(false)
    const [foco, setFoco] = useState(0);

    useEffect(() => {
        if(idUsuario === usuario.idUsuario){
            axios.get('/api/' + tipoUsuario + '/privacidad/publicacion/' + idPublicacion)
            .then(res => {
                if(res.headers["content-type"] == "application/json" && res.data !== undefined){
                    let valores = {
                        publico : Boolean(res.data.publico),
                        estudiante : Boolean(res.data.estudiantes),
                        profesor : Boolean(res.data.docentes),
                        directivo : Boolean(res.data.directivos),
                        load: true
                    }
                    setPrivacidad(valores)
                }
            })
        }
    },[usuario])

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    useEffect(() => {
        setEnviar(datos.titulo.length > 4 && datos.contenido.length > 0);
    },[datos])

    const eliminar = () => {
        axios.delete('/api/' + tipoUsuario + '/publicaciones/' + idPublicacion)
        .then(res => {
            if(res.status == 200){
                recargar();
            }
        })
    }

    const guardarCambios = (event) => {
        event.preventDefault();
        if(datos.titulo != titulo || datos.contenido != contenido){
            setCargando(true);
            const data = {
                titulo : datos.titulo,
                contenido : datos.contenido
            }
            axios.put('/api/' + tipoUsuario + '/publicaciones/' + idPublicacion, data)
            .then(res => {
                if(res.status == 200){
                    setEditando(false);
                }
            })
            setCargando(false);
        }else{
            setEditando(false);
        }
        
    }

    return (
        <div className="card shadow bg-white mt-2 py-4 px-4">
            <form onSubmit={guardarCambios}>
                <div className="container-fluid">
                    <div className="row">
                        <div className="col-md p-0 pr-3">
                            {/* Titulo de la publicacion */}
                            {editando ? 
                            <input 
                                className="form-control mb-3" 
                                maxLength="150" 
                                type="text" 
                                placeholder="Titulo" 
                                name="titulo" 
                                onChange={handleInputChange} 
                                onFocus={() => {setFoco(1)}}
                                onBlur={() => {setFoco(0)}}
                                value={datos.titulo}
                            />
                            :
                            <h3 className="text-primary">{datos.titulo}</h3>
                            }
                        </div>
                        <div className="col-md-auto p-0 text-right">
                            {/* hora de la publicacion */}
                            <span className="text-muted small">{fecha}</span>
                            {/* opciones de publicacion */}
                            { privacidad.load &&
                                <div className="d-inline-block">
                                    <span className="ml-3 icon-option" data-toggle="modal" data-target={"#privPublico-" + idPublicacion}>
                                        { privacidad.publico ?
                                        <i className="fas fa-globe-americas" ></i>
                                        :
                                        <i className="fas fa-users" ></i>
                                        }
                                    </span>
                                    <span onClick={() => {setEditando(!editando)}}>
                                        <i className="fas fa-edit mx-3 icon-option"></i>
                                    </span>
                                    <i className="fas fa-trash-alt icon-option"  data-toggle="modal" data-target="#deletePub"></i>
                                </div>
                            }
                        </div>
                    </div>
                </div>
                {/* contenido */}
                { editando ?
                <textarea 
                    className="form-control mb-3" 
                    maxLength="1000" 
                    name="contenido"  
                    onChange={handleInputChange} 
                    onFocus={() => {setFoco(2)}}
                    onBlur={() => {setFoco(0)}}
                    placeholder="Contenido..." 
                    value={datos.contenido}>
                </textarea>
                : 
                <p className="mb-3 text-justify">{datos.contenido}</p>
                }
                <div className="container-fluid">
                    <div className="row">
                        <div className="col p-0">
                            {/* Publicador */}
                            <UserInfoMini usuario={nombreUsuario} tipo={tipo} />
                        </div>
                        { editando ?
                        <div className="col d-flex justify-content-end align-items-center text-muted pr-0">
                            {foco != 0 &&
                                <span className="mr-2 text-muted pt-1">{foco == 1 ? datos.titulo.length : datos.contenido.length}/{foco == 1 ? "150" : "1000"}</span>
                            }
                            <button type="submit" className="btn btn-sm px-4 bg-info text-light" disabled={!enviar}>
                                {cargando ?
                                    <span className="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
                                :
                                    <i className="fas fa-check mr-2"></i>
                                }
                                <span>Aceptar</span>
                            </button>
                        </div>
                        :
                        <BtnsLike conlike={conlike} condislike={condislike} idPublicacion={idPublicacion} likes={likes} dislikes={dislikes} />
                        }
                    </div>
                </div>
            </form>
            { privacidad.load &&
            <div>
                <ModalConfirmar id="deletePub" text="¿Quieres eliminar esta publicación?" eliminar={true} confirmar={eliminar}/>
                <ModalPrivacidad id={"privPublico-" + idPublicacion} privacidad={privacidad} setPrivacidad={setPrivacidad}/>
            </div>
            }
        </div>
    )
}

Publicacion.propTypes = {
    titulo: propTypes.string, 
    fecha: propTypes.string, 
    contenido: propTypes.string,
    nombreUsuario: propTypes.string, 
    tipo: propTypes.string, 
    likes: propTypes.number, 
    dislikes: propTypes.number,
    idUsuario: propTypes.number,
    idPublicacion: propTypes.number,
    conlike: propTypes.bool,
    condislike: propTypes.bool,
    recargar: propTypes.func
}

export default Publicacion
