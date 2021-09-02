import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';

function Example() {

    const [datos, setDatos] = useState({
        usuario: '',
        contrasena: ''
    });

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    const enviarDatos = (event) => {
        event.preventDefault();

        let login = {
            user: datos.usuario,
            password: datos.contrasena
        }

        axios.post('api/auth/login',login)
        .then(res => {
            console.log(res.data);
        }).catch(err => {
            if (err.response) {
                console.log(err.response.data);
            }
        })
        .then(() => {
            
        })
    }

    return (
        <div className="container">
            <div className="row justify-content-center">
                <div className="col-md-8">
                    <div className="card">
                        <form onSubmit={enviarDatos}>
                            <div className="form-group mb-1">
                                <label htmlFor="usuario" className="mb-0 ml-3 text-dark tituloCampo">Usuario</label>
                                <input type="text" id="usuario" name="usuario"  onChange={handleInputChange} className="form-control rounded-pill" placeholder="Email o número de documento"  required={true}/>
                            </div>
                            <div className="form-group mb-0">
                                <label htmlFor="contrasena" className="mb-0 ml-3 text-dark tituloCampo">Contraseña</label>
                                <input type="password" id="contrasena" name="contrasena" onChange={handleInputChange} className="form-control rounded-pill" placeholder="contraseña" value={datos.contrasena} required={true}/>
                            </div>
                            <button type="submit">INGRESAR</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Example;

if (document.getElementById('example')) {
    ReactDOM.render(<Example />, document.getElementById('example'));
}
