import React, { useEffect, useState } from 'react';
import peticion from '../utils/peticion';
import ModalPriv from './modalPriv';

const NuevoEvento = (props) => {

    const [datos, setDatos] = useState({
        hora : '13:00',
        descripcion : ''
    });
    const [validar,setValidar] = useState(false);
    const [cargando,setCargando] = useState(false);
    const [privacidad, setPrivacidad] = useState({
        publico : true,
        estudiante : true,
        profesor : true,
        directivo :true
    });

    useEffect(() => {
        let expHora = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/
        setValidar(datos.descripcion.length > 4 && expHora.test(datos.hora));
    },[datos])

    const handleInputChange = (event) => {
        setDatos({
            ...datos,
            [event.target.name] : event.target.value
        })
    }

    const agregar = (event) => {
        event.preventDefault();
        setValidar(false)
        setCargando(true)
        let month = props.mes + 1;
        let fecha = props.ano + '-' + ((month < 10  ? '0' : '') + month) + '-' + (props.dia < 10  ? '0' : '') + props.dia;
        let datosEnv = {
            hora: fecha + ' ' + datos.hora + ':00',
            descripcion: datos.descripcion,
            publico: privacidad.publico ? 1 : 0,
            directivo: privacidad.directivo ? 1 : 0,
            profesor: privacidad.profesor ? 1 : 0,
            estudiante:privacidad.estudiante ? 1 : 0,
        }
        peticion('eventos','POST', datosEnv)
        .then(res => {
            setDatos({
                hora : '13:00',
                descripcion : ''
            })
            props.obtenerEventos(props.ano, props.mes, props.dia);
            props.obtenerFechas(props.ano, props.mes + 1);
            setValidar(false)
        })
        .catch(err => {
            setValidar(true)
        })
        .then(() => {
            setCargando(false)
        })
    }

    return <div className="accordion mb-3"  id="accordionNewEvent">
        <div className="card" style={{borderRadius:"20px"}}>
            <div className="card-header p-0" id="headingOne">
                <button className="btn btn-block btn-primary text-center" type="button" data-toggle="collapse" data-target="#newEvent" aria-expanded="true" aria-controls="newEvent">
                    <i className="fas fa-plus mr-2"></i> Nuevo Evento
                </button>
            </div>
            <div id="newEvent" className="collapse" aria-labelledby="headingOne" data-parent="#accordionNewEvent">
            <form onSubmit={agregar}>
                <div className="card-body py-2">
                        <div className="form-group row mb-2">
                            <label htmlFor="staticEmail" className="col-sm-4 col-form-label text-right">Hora:</label>
                            <div className="col-sm-8">
                                <input 
                                    type="time" 
                                    name="hora"
                                    className="form-control" 
                                    value={datos.hora}
                                    onChange={handleInputChange} 
                                    placeholder="HH:MM"
                                />
                            </div>
                        </div>
                        <div className="form-group mb-0">
                            <textarea 
                                className="form-control" 
                                name="descripcion"
                                rows="2" 
                                onChange={handleInputChange} 
                                value={datos.descripcion}
                                placeholder="Evento..." 
                                maxLength="100" 
                            ></textarea>
                        </div>
                        <div className="d-flex justify-content-between mt-2">
                            <small className="text-muted">{datos.descripcion.length}/100</small>
                            <button type="button" className="btn btn-outline-secondary btn-sm px-3"  data-toggle="modal" data-target="#privEvento">
                                {privacidad.publico ?
                                <i className="fas fa-globe-americas mr-2"></i>
                                : 
                                <i className="fas fa-users mr-2"></i>}
                                Privacidad
                            </button>
                        </div>
                </div>
                <div className="card-footer p-0" id="headingOne">
                    <button 
                        className="btn btn-block btn-primary text-center" 
                        type="submit" 
                        disabled={!validar}
                    >
                    {cargando ?
                        <span className="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>
                    :
                        <i className="fas fa-share mr-2"></i>
                    }
                    Agregar
                    </button>
                </div>
            </form>
            </div>
        </div>
        <ModalPriv id="privEvento" privacidad={privacidad} setPrivacidad={setPrivacidad}/>
    </div>

}

export default NuevoEvento;