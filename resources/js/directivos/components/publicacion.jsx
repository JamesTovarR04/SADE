import React, { useEffect, useState } from 'react';

import '../styles/publicacion.css';
import peticion from '../utils/peticion';
import ModalConfirmar from './modalConfirmar';
import ModalPriv from './modalPriv';

const Publicacion = (props) => {

    const idUsuario = JSON.parse(localStorage["user-data"]).idUsuario;
    const URL = 'publicaciones/' + props.id;

    const [like, setLike] = useState(props.conlike);
    const [dislike, setDislike] = useState(props.condislike);
    const [totalLikes, setTotalLikes] = useState(props.likes);
    const [totalDislikes, setTotalDislikes] = useState(props.dislikes);
    const [propiedad, setPropiedad] = useState(idUsuario == props.idUsuario);
    const [editando, setEditando] = useState(false);
    const [datos, setDatos] = useState({
        titulo: props.titulo,
        contenido: props.contenido
    });
    const [privacidad, setPrivacidad] = useState({
        publico : false,
        estudiante : false,
        profesor : false,
        directivo :false,
        load: false
    });
    const [cargando,setCargando] = useState(false);
    const [enviar, setEnviar] = useState(false);
    const [foco, setFoco] = useState(0);

    useEffect(() => {
        if(propiedad){
            const URL_priv = 'privacidad/publicacion/' + props.id;
            peticion(URL_priv)
            .then(res => {
                let valores = {
                    publico : res.publico,
                    estudiante : res.estudiantes,
                    profesor : res.docentes,
                    directivo :res.directivos,
                    load: true
                }
                setPrivacidad(valores)
            })
            .catch(err => {
                setEditando(false)
            })
        }
    },[])

    useEffect(() => {
        setEnviar(datos.titulo.length > 4 && datos.contenido.length > 0);
    },[datos])

    const eliminar = () => {
        peticion(URL,'DELETE')
        .then(res => {
            props.recargar();
        })
        .catch(err => {
            alert("No se pudo elimar el recurso")
        })
    }

    const guardarCambios = (event) => {
        event.preventDefault();
        if(datos.titulo != props.titulo || datos.contenido != props.contenido){
            setCargando(true);
            const data = {
                titulo : datos.titulo,
                contenido : datos.contenido
            }
            peticion(URL,'PUT', data)
            .then(res => {
                setEditando(false);
            })
            setCargando(false);
        }else{
            setEditando(false);
        }
        
    }

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    const sendLike = () => {
        if(dislike) sendDislike();
        setLike(!like)
        peticion(URL + '/like')
        .then(res => {
            setLike(res.like)
            if(res.like)
                setTotalLikes(totalLikes + 1)
            else
                setTotalLikes(totalLikes - 1)
        })
        .catch(err => {
            setTotalLikes(props.like)
        })
    }

    const sendDislike = () => {
        if(like) sendLike();
        setDislike(!dislike)
        peticion(URL  + '/dislike')
        .then(res => {
            setDislike(res.dislike)
            if(res.dislike)
                setTotalDislikes(totalDislikes + 1)
            else
                setTotalDislikes(totalDislikes - 1)
        })
        .catch(err => {
            setTotalLikes(props.dislike)
        })
    }

    return <div className="card publicacion shadow bg-white mt-2 py-4 px-5">
        <form onSubmit={guardarCambios}>
            <div className="container-fluid">
                <div className="row">
                    <div className={"p-0 " + (propiedad ? "col-7" : "col-8")}>
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
                        <h3 className="h5">{datos.titulo}</h3>
                        }
                    </div>
                    <div className={"p-0 text-right " + (propiedad ? "col-5" : "col-4")}>
                        {/* hora de la publicacion */}
                        <span className="text-muted">{props.fecha}</span>
                        { propiedad &&
                            <div className="d-inline-block">
                                {privacidad.publico ?
                                <i className="fas fa-globe-americas ml-3 icon-option" data-toggle="modal" data-target={"#privPublico-" + props.id}></i>
                                :
                                <i className="fas fa-users ml-3 icon-option" data-toggle="modal" data-target={"#privPublico-" + props.id}></i>
                                }
                                <i className="fas fa-edit mx-3 icon-option" onClick={() => {setEditando(!editando)}}></i>
                                <i className="fas fa-trash-alt icon-option"  data-toggle="modal" data-target="#deletePub"></i>
                            </div>
                        }
                    </div>
                </div>
            </div>
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
            {editando &&
            <div className="d-flex justify-content-end mb-3">
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
            }
        </form>
        <div className="container-fluid">
            <div className="row">
                <div className="col p-0">
                    {/* Publicador */}
                    <div className="container p-0">
                        <div className="col p-0">
                            <div className="d-flex">
                                <img src="/images/notUser.jpg" className="image-user rounded-circle"/>
                                <div className="container ml-2">
                                    <div className="row">
                                        <span className="name-user">{props.usuario}</span>
                                    </div>
                                    <div className="row">
                                        <em className="text-muted text-uppercase">{props.tipo}</em>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col d-flex justify-content-end align-items-center text-muted">
                    <div className="mr-2">
                        <i className={"fas fa-heart icon-like " + (like ? "text-danger"  : "")} onClick={sendLike}></i>
                    </div>
                    <div className="mr-3 mb-1">
                        {/* Likes */}
                        <span>{totalLikes}</span>
                    </div>
                    <div className="mr-2">
                        <i className={"fas fa-heart-broken icon-like " + (dislike ? "text-danger"  : "")} onClick={sendDislike}></i>
                    </div>
                    <div className="mb-1 mr-3">
                        {/* Dislikes */}
                        <span>{totalDislikes}</span>
                    </div>
                </div>
            </div>
        </div>
        <ModalConfirmar id="deletePub" text="¿Quieres eliminar esta publicación?" eliminar={true} confirm={eliminar}/>
        {privacidad.load && <ModalPriv id={"privPublico-" + props.id} onlyView={true} privacidad={privacidad}/>}
    </div>

}

export default Publicacion;