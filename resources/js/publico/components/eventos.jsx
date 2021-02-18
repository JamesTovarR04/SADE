import React, { useEffect, useState } from 'react';
import peticion from '../utils/peticion';
import Calendario from './calendarios';
import Evento from './evento';
import {meses} from '../utils/fecha';
import Cargando from './cargando';

const Eventos = () => {

    let today = new Date();

    const [fechas,setFechas] = useState([]);
    const [dia, setDia] = useState(today.getDate());
    const [mes, setMes] = useState(today.getMonth());
    const [ano, setAno] = useState(today.getFullYear());
    const [cargando, setCargando] = useState(true);
    const [eventos, setEventos] = useState([]);

    useEffect(() => {
        obtenerEventos(ano,mes,dia)
    },[dia]);

    function obtenerEventos(year,month,day){
        month++;
        let mes = (month < 10 ? '0' : '') + month;
        let dia = (day < 10  ? '0' : '') + day;
        peticion('eventos','GET',{
            'dia' : year + '-' + mes + '-' + dia
        }).then(data => { 
            setEventos(data)
            setCargando(false)
        })
    }

    function obtenerFechas(year,month){
        let data = {
            'mes' : year + '-' + (month < 10 ? '0' : '') + month,
        }
        peticion('eventos/mes','GET',data,true)
        .then(data => {
            setFechas(data)
        })
    }

    function clickDia(year,month,day){
        setDia(day);
        setMes(month-1);
        setAno(year);
        //obtenerEventos(year,month,day)
    }

    function cambioMes(year,month){
        obtenerFechas(year,month)
    }

    return <div className="my-3">
        <h2 className="h5"><i className="fas fa-calendar-alt mr-1"></i> Eventos</h2>
        <div className="card shadow p-3 mt-3"><Calendario fechas={fechas} clickDia={clickDia} cambioMes={cambioMes}/></div>
        <div className="mt-2">
            <span className="d-block text-center h5 mb-3">Eventos {dia} de {meses[mes]}</span>
            {cargando ? <Cargando/>
            : <div>
                {eventos.length == 0 ? <div className="text-center text-muted">No hay eventos para este dia</div>
                : eventos.map(evento => (
                    <Evento
                    key={evento.idEventos}
                    hora={evento.hora}
                    descripcion={evento.descripcion}
                    />
                ))}
            </div>
            }
        </div>
    </div>

}

export default Eventos;