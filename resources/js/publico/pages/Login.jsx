import React, { useState } from 'react'
import Button from '../../components/Button';
import { typeUser } from '../../helpers/typeUser';

const Login = () => {

    const [datos, setDatos] = useState({
        user: '',
        password: ''
    })
    const [codeError, setCodeError] = useState(0)
    const [cargando, setCargando] = useState(false);

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name]: event.target.value
        })
    }

    const enviarDatos = (event) => {
        event.preventDefault();
        setCargando(true)
        axios.post('api/auth/login', datos)
            .then(res => {
                // handle success
                if (res.status == 200) {
                    window.location.assign('/' + typeUser(res.data.user.tipo));
                }
            }).catch(err => {
                if (err.response) {
                    setCodeError(err.response.data.code);
                    setDatos({
                        ...datos,
                        password: ''
                    })
                }
            })
            .then(res => {
                setCargando(false)
            })
    }

    return (
        <div className="container-fluid page-container p-0">
            <div className="bg-login d-flex justify-content-center align-items-center" style={{ minHeight: "90vh" }}>
                <div className="card bg-light shadow-lg" style={{ minWidth: "330px" }}>
                    <div className="container p-0">
                        <div className="row mb-2 mt-3">
                            <div className="col d-flex justify-content-center m-0 py-2">
                                <img src="/images/logo-azul.svg" height="35" />
                            </div>
                        </div>
                        <h2 className="line-title mb-0 text-primary">Iniciar Sesión</h2>
                        <form className="mx-3 my-1" onSubmit={enviarDatos}>
                            <fieldset>
                                <div className="form-group mb-1">
                                    <label htmlFor="usuario" className="mb-0 ml-3 text-dark tituloCampo">Usuario</label>
                                    <input type="text" id="usuario" name="user" onChange={handleInputChange} className="form-control" value={datos.user} placeholder="Email o número de documento" required={true} />
                                </div>
                                <div className="form-group mb-0">
                                    <label htmlFor="contrasena" className="mb-0 ml-3 text-dark tituloCampo">Contraseña</label>
                                    <input type="password" id="contrasena" name="password" onChange={handleInputChange} className="form-control" placeholder="contraseña" value={datos.password} required={true} />
                                </div>
                                <div className="text-center">
                                    {(codeError == 2)
                                        ? <span className="text-danger small">Usuario o contraseña incorrecta</span>
                                        : (codeError == 3) && <span className="text-danger small">El usuario fue bloqueado</span>
                                    }
                                </div>
                                <div className="text-center mb-2 mt-1">
                                    <a href="#" className="small color-sade-2">¿olvidaste tu contraseña?</a>
                                </div>
                                <Button text="INGRESAR" cargando={cargando} addClass="btn-primary w-100" type="submit" />
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
            <div className="container p-4" id="info-resgistro">
                <div className="row justify-content-center align-items-center">
                    <div className="col-auto mb-3">
                        <img src="/images/register-info.jpg" height="80" />
                    </div>
                    <div className="col-md">
                        <h3 className="text-primary">Información De Registro</h3>
                        <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. In perspiciatis praesentium ullam! Voluptate magni dolore nesciunt. Sequi sint omnis totam, nostrum beatae nisi odit veniam!</p>
                    </div>
                </div>
            </div>
        </div>
    );

}

export default Login
