import React from 'react';

import '../styles/publicacion.css';

const Publicacion = (props) => {

    return <div className="card publicacion shadow bg-white mt-2 py-4 px-5">
        <div className="container-fluid">
            <div className="row">
                <div className="col-9 p-0">
                    {/* Titulo de la publicacion */}
                    <h3 className="h5">{props.titulo}</h3>
                </div>
                <div className="col-3 p-0 text-right">
                    {/* hora de la publicacion */}
                    <span className="text-muted">{props.fecha}</span>
                </div>
            </div>
        </div>
        {/* contenido */}
        <p className="mb-3 text-justify">{props.contenido}</p>
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
                        <i className="fas fa-heart icon-like"></i>
                    </div>
                    <div className="mr-3 mb-1">
                        {/* Likes */}
                        <span>{props.likes}</span>
                    </div>
                    <div className="mr-2">
                        <i className="fas fa-heart-broken icon-like"></i>
                    </div>
                    <div className="mb-1 mr-3">
                        {/* Dislikes */}
                        <span>{props.dislikes}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

}

export default Publicacion;