import React, { useState } from 'react';
import { URL_SERVER } from '../config';
import axios from 'axios';

import "../styles/login.css";

const Login = () => {

    const [datos, setDatos] = useState({
        usuario: '',
        contrasena: ''
    });
    const [cargando,setCargando] = useState(false);
    const [codeError, setCodeError] = useState(0);

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
        setCodeError(0);
    }

    const enviarDatos = (event) => {
        event.preventDefault();
        setCargando(true);

        let login = {
            user: datos.usuario,
            password: datos.contrasena
        }

        axios.post(URL_SERVER + '/api/auth/login',login)
        .then(res => {
            let userData = {
                rol: res.data.rol,
                nombre: res.data.usuario,
                access_token: res.data.token_type + ' ' + res.data.access_token,
                axpires_at: res.data.expires_at
            };
            let appState = {
                isLoggedIn: true,
                user: userData
            };
            localStorage["session"] = JSON.stringify(appState);
            window.location.assign('/'+res.data.rol);
        }).catch(err => {
            if (err.response) {
                setCodeError(err.response.data.code);
                setDatos({
                    ...datos,
                    contrasena : ''
                })
            }
        })
        .then(() => {
            setCargando(false);
        })
    }


    return <div className="">
        <div className="bg-login d-flex justify-content-center align-items-center" style={{minHeight:"90vh"}}>
            <div className="card bg-light shadow-lg">
                <div className="container p-0">
                    <div className="row mb-2 mt-3">
                        <div className="col d-flex justify-content-center">
                            <img src="/images/logo-azul.svg" height="30"/>
                        </div>
                    </div>
                    <h2 className="titulo mb-0">Iniciar Sesion</h2>
                    <form className="mx-3 my-1" onSubmit={enviarDatos}>
                        <fieldset>
                            <div className="form-group mb-1">
                                <label htmlFor="usuario" className="mb-0 ml-3 text-dark tituloCampo">Usuario</label>
                                <input type="text" id="usuario" name="usuario"  onChange={handleInputChange} className="form-control rounded-pill" placeholder="Email o número de documento"  required={true}/>
                            </div>
                            <div className="form-group mb-0">
                                <label htmlFor="contrasena" className="mb-0 ml-3 text-dark tituloCampo">Contraseña</label>
                                <input type="password" id="contrasena" name="contrasena" onChange={handleInputChange} className="form-control rounded-pill" placeholder="contraseña" value={datos.contrasena} required={true}/>
                            </div>
                            <div className="text-center">
                            {(codeError == 2)
                                ? <span className="text-danger small">Usuario o contraseña incorrecta</span>
                                : (codeError == 3) && <span className="text-danger small">El usuario fue bloqueado</span>
                            }
                            </div>
                            <div className="text-center mb-2">
                                <a href="#" className="small color-sade-2">¿olvidaste tu contraseña?</a>
                            </div>
                            <button 
                            className={"btn btn-primary rounded-pill " + (cargando && 'disabled')} 
                            type="submit"
                            >
                                {cargando && <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>}
                                <span className={cargando ? 'ml-2' : ''}>INGRESAR</span>
                            </button>
                            <div className="text-center">
                                <a href="#info-resgistro" className="small color-sade-2">INFORMACION DE REGISTRO</a>
                            </div>
                            <div className="text-center">
                                <i className="fas fa-caret-down color-sade-2"></i>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
        <div className="d-flex justify-content-center p-4 align-items-center" id="info-resgistro">
            <img src="/images/register-info.jpg" height="80"/>
            <div className="ml-3 w-50">
                <h3 className="h5 color-sade-2">Información De Registro</h3>
                <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. In perspiciatis praesentium ullam! Voluptate magni dolore nesciunt. Sequi sint omnis totam, nostrum beatae nisi odit veniam!</p>
            </div>
        </div>
    </div>

}

export default Login;