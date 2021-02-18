import React, { useState } from 'react';
import peticion from '../utils/peticion';

const Publicar = (props) => {

    const [datos, setDatos] = useState({
        titulo: '',
        contenido: ''
    });

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    const enviarDatos = (event) => {
        event.preventDefault();
        //setCargando(true);

        let enviardatos = {
            titulo: datos.titulo,
            contenido: datos.contenido,
            publico: 1,
            directivo: 0,
            profesor: 0,
            estudiante: 0,
        }

        peticion('publicaciones','POST',enviardatos)
        .then(res => {
            setDatos({
                titulo: '',
                contenido: ''
            })
            props.recargar();
        }).catch(err => {
            if (err.response) {

            }
        })
        .then(() => {
            //setCargando(false);
        })
    }

    return <div className="card publicacion shadow bg-white mt-2 py-4 px-5">
        <form onSubmit={enviarDatos}>
            <div className="d-flex bd-highlight">
                <label htmlFor="staticEmail" className="p-2 color-sade-1">
                    <i className="fas fa-user-circle" style={{fontSize: "2em"}}></i>
                </label>
                <div className="pl-2 py-2 w-100 bd-highlight">
                    <input className="form-control" type="text" placeholder="Titulo" name="titulo" onChange={handleInputChange} value={datos.titulo} required/>
                </div>
            </div>
            <div className="form-group">
                <textarea className="form-control" id="exampleFormControlTextarea1" name="contenido"  onChange={handleInputChange} rows="1" placeholder="Contenido..." value={datos.contenido}  required></textarea>
            </div>
            <div className="d-flex justify-content-end">
                <button type="submit" className="btn btn-primary px-5 bg-info">Publicar</button>
            </div>
        </form>
    </div>

}

export default Publicar;