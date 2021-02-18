import React from 'react';
import { Link } from 'react-router-dom';
import { logout } from '../../publico/utils/login';

const BotonLogin = (props) =>{

    function closeSession(){
        logout();
        window.location.assign('/');
    }

    return <div className="btn-group">
        <div>
            <button type="button" className="btn btn-light rounded-pill p-0 d-flex align-items-center" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <div>
                    <i className="fas fa-user-circle color-sade-1" style={{margin:"5px",fontSize:"1.5em"}}></i>
                </div>
                <div className="mr-3 ml-2 pr-3 pl-2">
                    <div className="row">
                        <span className="name-user" style={{lineHeight:"1em",fontSize:"0.9em"}}>{JSON.parse(localStorage["session"]).user.nombre}</span>
                    </div>
                    <div className="row">
                        <em className="text-muted text-uppercase" style={{lineHeight:"1.4",fontSize:"0.5em"}}>{JSON.parse(localStorage["session"]).user.rol}</em>
                    </div>
                </div>
            </button>
            <div className="dropdown-menu dropdown-menu-right">
                <button className="dropdown-item" type="button">
                    <Link to={`${'/'+JSON.parse(localStorage["session"]).user.rol}/perfil`} className="text-decoration-none text-body">
                        <i className="fas fa-cogs mr-3"></i>
                        Perfil
                    </Link>
                </button>
                <button className="dropdown-item" type="button" onClick={closeSession}>
                    <i className="fas fa-sign-out-alt mr-3"></i>
                    Cerrar Sesión
                </button>
            </div>
        </div>
    </div>

}

export default BotonLogin;