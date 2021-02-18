import React from 'react';
import { Link } from 'react-router-dom';
import { isLogin, logout } from '../utils/login';

const BotonLogin = (props) =>{

    function closeSession(){
        logout();
        window.location.assign('/');
    }

    function plataforma(){
        window.location.assign('/'+JSON.parse(localStorage["session"]).user.rol)
    }

    return <div className="btn-group">
        {isLogin()
        ?<div>
            <button type="button" className="btn btn-primary rounded-pill p-0 d-flex align-items-center" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <div>
                    <i className="fas fa-user-circle" style={{margin:"5px",fontSize:"1.5em"}}></i>
                </div>
                <div className="mr-3 ml-2">
                    <span>{JSON.parse(localStorage["session"]).user.nombre}</span>
                </div>
            </button>
            <div className="dropdown-menu dropdown-menu-right">
                {props.public === true
                ?<button className="dropdown-item" type="button" onClick={plataforma}>
                    <i className="fas fa-dice-d6 mr-3"></i>
                    Plataforma
                </button>
                :<button className="dropdown-item" type="button">
                    <i className="fas fa-cogs mr-3"></i>
                    Perfil
                </button>
                }
                <button className="dropdown-item" type="button" onClick={closeSession}>
                    <i className="fas fa-sign-out-alt mr-3"></i>
                    Cerrar Sesión
                </button>
            </div>
        </div>
        : <Link to="/login" className="btn btn-primary rounded-pill p-0 d-flex align-items-center">
            <div>
                <i className="fas fa-user-circle" style={{margin:"5px",fontSize:"1.5em"}}></i>
            </div>
            <div className="mr-3 ml-2">
                <span>Iniciar Sesión</span>
            </div>
        </Link>
        }
    </div>

}

export default BotonLogin;