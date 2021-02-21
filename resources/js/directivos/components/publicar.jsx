import React, { useEffect, useState } from 'react';
import peticion from '../utils/peticion';
import ModalPriv from './modalPriv';

const Publicar = (props) => {

    const [datos, setDatos] = useState({
        titulo: '',
        contenido: ''
    });
    const [privacidad, setPrivacidad] = useState({
        publico : true,
        estudiante : true,
        profesor : true,
        directivo :true
    });
    const [cargando,setCargando] = useState(false);
    const [enviar, setEnviar] = useState(false);
    const [foco, setFoco] = useState(0);

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    useEffect(() => {
        setEnviar(datos.titulo.length > 4 && datos.contenido.length > 0);
    },[datos])

    const enviarDatos = (event) => {
        event.preventDefault();
        setCargando(true);
        setEnviar(false);

        let enviardatos = {
            titulo: datos.titulo,
            contenido: datos.contenido,
            publico: privacidad.publico ? 1 : 0,
            directivo: privacidad.directivo ? 1 : 0,
            profesor: privacidad.profesor ? 1 : 0,
            estudiante:privacidad.estudiante ? 1 : 0,
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
            setCargando(false);
        })
    }

    return <div className="card publicacion shadow bg-white mt-2 py-3 px-5">
        <form onSubmit={enviarDatos}>
            <div className="d-flex bd-highlight">
                <img className="rounded-circle" src="/images/notUser.jpg" height="38px"/>
                <div className="pl-2 pb-2 w-100 bd-highlight">
                    <input 
                        className="form-control" 
                        maxLength="150" 
                        type="text" 
                        placeholder="Titulo" 
                        name="titulo" 
                        onChange={handleInputChange} 
                        onFocus={() => {setFoco(1)}}
                        onBlur={() => {setFoco(0)}}
                        value={datos.titulo}
                    />
                </div>
            </div>
            <div className="form-group mb-2">
                <textarea 
                    className="form-control" 
                    maxLength="1000" 
                    name="contenido"  
                    onChange={handleInputChange} 
                    onFocus={() => {setFoco(2)}}
                    onBlur={() => {setFoco(0)}}
                    rows="1" 
                    placeholder="Contenido..." 
                    value={datos.contenido}>
                </textarea>
            </div>
            <div className="d-flex justify-content-end">
                {foco != 0 &&
                    <span className="mr-2 text-muted pt-1">{foco == 1 ? datos.titulo.length : datos.contenido.length}/{foco == 1 ? "150" : "1000"}</span>
                }
                <button type="button" className="btn btn-outline-secondary btn-sm px-3 mr-2"  data-toggle="modal" data-target="#privPublico">
                    {privacidad.publico ?
                    <i className="fas fa-globe-americas mr-2"></i>
                    : 
                    <i className="fas fa-users mr-2"></i>}
                    Privacidad
                </button>
                <button type="submit" className="btn btn-sm px-4 btn-primary text-light" disabled={!enviar}>
                    {cargando ?
                        <span className="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
                    :
                        <i className="fas fa-share mr-2"></i>
                    }
                    <span>Publicar</span>
                </button>
            </div>
        </form>
        <ModalPriv id="privPublico" privacidad={privacidad} setPrivacidad={setPrivacidad}/>
    </div>

}

export default Publicar;