import React, { useContext, useEffect, useState } from 'react';
import { GlobalContext } from '../context/GlobalState';

import formatoHora from '../helpers/formatoHora'
import ModalConfirmar from '../components/Modales/ModalConfirmar'
import axios from 'axios';

const Evento = ({
    hora, 
    descripcion, 
    idUsuario = -1,
    idEvento,
    recargar
}) => {

    const { usuario, tipoUsuario } = useContext(GlobalContext)

    const [color,setColor] = useState('bg-secondary');
    const [horaFormat,setHoraFormat] = useState('00:00 --');

    useEffect(() => {
        let colors = ['bg-info','bg-success','bg-primary'];
        setColor(colors[Math.floor(Math.random()*(colors.length))]);
        setHoraFormat(formatoHora(hora))
    },[]);

    const eliminar = () => {
        axios.delete('/api/'+ tipoUsuario + '/eventos/' + idEvento)
        .then(res => {
            recargar()
        })
        .catch(err => {
            alert("No se pudo eliminar el recurso")
        })
    }

    return <div className={color + " card mt-2 text-white"} style={{borderRadius: "20px"}}>
         <div className="card-header text-white d-flex">
            <div className="flex-grow-1">
                <strong>{horaFormat}</strong>
            </div>
            {usuario.idUsuario === idUsuario &&
            <div>
                <i className="fas fa-times" data-toggle="modal" data-target={"#deleteEvent-" + idEvento} style={{cursor: "pointer"}}></i>
            </div>
            }
        </div>
        <div className="card-body text-white">
            <span>{descripcion}</span>
        </div>
        <ModalConfirmar id={"deleteEvent-" + idEvento} texto="¿Quieres cancelar este evento?" eliminar={true} confirmar={eliminar}/>
    </div>

}

export default Evento;