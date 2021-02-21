import React, { useEffect, useState } from 'react';
import peticion from '../utils/peticion';
import ModalConfirmar from './modalConfirmar';

const Evento = (props) => {

    const idUsuario = JSON.parse(localStorage["user-data"]).idUsuario;

    const [color,setColor] = useState('bg-secondary');
    const [hora,setHora] = useState('00:00 --');
    const [propiedad, setPropiedad] = useState(idUsuario == props.idUsuario);

    useEffect(() => {
        let colors = ['bg-info','bg-success','bg-primary'];
        setColor(colors[Math.floor(Math.random()*(colors.length))]);
        var fecha = new Date(props.hora);
        var horaF = '';
        if(fecha.getHours() > 12 || fecha.getHours() == 0){
            horaF = Math.abs(fecha.getHours()-12) + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + ((fecha.getHours() == 0)? ' a.m.' : ' p.m');
        }else{
            horaF = fecha.getHours() + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + " a.m.";
        }
        setHora(horaF)
    },[]);

    const eliminar = () => {
        const URL = 'eventos/' + props.id;
        peticion(URL,'DELETE')
        .then(res => {
            props.recargar();
        })
        .catch(err => {
            alert("No se pudo elimar el recurso")
        })
    }

    return <div className={color + " card mt-2"} style={{borderRadius: "20px"}}>
        <div className="card-header text-white d-flex">
            <div className="flex-grow-1">
                <strong>{hora}</strong>
            </div>
            {propiedad &&
            <div>
                <i className="fas fa-times" data-toggle="modal" data-target="#deleteEvent" style={{cursor: "pointer"}}></i>
            </div>
            }
        </div>
        <div className="card-body text-white">
            <span>{props.descripcion}</span>
        </div>
        <ModalConfirmar id="deleteEvent" text="¿Quieres cancelar este evento?" eliminar={true} confirm={eliminar}/>
    </div>

}

export default Evento;