import React, { memo } from 'react'
import propTypes from 'prop-types'
import UserInfoMini from './UserInfoMini'

const Publicacion = ({
    titulo, 
    fecha, 
    contenido,
    usuario, 
    tipo, 
    likes, 
    dislikes
}) => {
    return (
        <div className="card shadow bg-white mt-2 py-4 px-4">
            <div className="container-fluid">
                <div className="row">
                    <div className="col-md-9 p-0">
                        {/* Titulo de la publicacion */}
                        <h3 className="text-primary">{titulo}</h3>
                    </div>
                    <div className="col-md-3 p-0 text-right">
                        {/* hora de la publicacion */}
                        <span className="text-muted small">{fecha}</span>
                    </div>
                </div>
            </div>
            {/* contenido */}
            <p className="mb-3 text-justify">{contenido}</p>
            <div className="container-fluid">
                <div className="row">
                    <div className="col p-0">
                        {/* Publicador */}
                        <UserInfoMini usuario={usuario} tipo={tipo} />
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
        </div>
    )
}

Publicacion.propTypes = {
    titulo: propTypes.string, 
    fecha: propTypes.string, 
    contenido: propTypes.string,
    usuario: propTypes.string, 
    tipo: propTypes.string, 
    likes: propTypes.number, 
    dislikes: propTypes.number,
}

export default memo(Publicacion)
