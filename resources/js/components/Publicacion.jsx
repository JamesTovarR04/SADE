import React, { useContext, useEffect, useState } from 'react'
import propTypes from 'prop-types'
import UserInfoMini from './UserInfoMini'
import { GlobalContext } from '../context/GlobalState'
import axios from 'axios'
import ModalPrivacidad from './Modales/ModalPrivacidad'

const Publicacion = ({
    titulo, 
    fecha, 
    contenido,
    nombreUsuario, 
    tipo, 
    likes, 
    dislikes,
    idUsuario = null,
    idPublicacion = null
}) => {

    const { usuario } = useContext(GlobalContext)

    const [privacidad, setPrivacidad] = useState({
        publico : false,
        estudiante : false,
        profesor : false,
        directivo :false,
        load: false
    })

    useEffect(() => {
        if(idUsuario === usuario.idUsuario){
            axios.get('/api/directivo/privacidad/publicacion/' + idPublicacion)
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

    return (
        <div className="card shadow bg-white mt-2 py-4 px-4">
            <div className="container-fluid">
                <div className="row">
                    <div className="col-md p-0">
                        {/* Titulo de la publicacion */}
                        <h3 className="text-primary">{titulo}</h3>
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
                                <i className="fas fa-edit mx-3 icon-option" onClick={() => {setEditando(!editando)}}></i>
                                <i className="fas fa-trash-alt icon-option"  data-toggle="modal" data-target="#deletePub"></i>
                            </div>
                        }
                    </div>
                </div>
            </div>
            {/* contenido */}
            <p className="mb-3 text-justify">{contenido}</p>
            <div className="container-fluid">
                <div className="row">
                    <div className="col p-0">
                        {/* Publicador */}
                        <UserInfoMini usuario={nombreUsuario} tipo={tipo} />
                    </div>
                    <div className="col d-flex justify-content-end align-items-center text-muted">
                        <div className="mr-2">
                            <i className="fas fa-heart icon-like"></i>
                        </div>
                        <div className="mr-3 mb-1">
                            {/* Likes */}
                            <span>{likes}</span>
                        </div>
                        <div className="mr-2">
                            <i className="fas fa-heart-broken icon-like"></i>
                        </div>
                        <div className="mb-1 mr-3">
                            {/* Dislikes */}
                            <span>{dislikes}</span>
                        </div>
                    </div>
                </div>
            </div>
            { privacidad.load &&
            <ModalPrivacidad id={"privPublico-" + idPublicacion} privacidad={privacidad} setPrivacidad={setPrivacidad}/>
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
    idPublicacion: propTypes.number
}

export default Publicacion
