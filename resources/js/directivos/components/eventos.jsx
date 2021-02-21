import React, { useEffect, useState } from 'react';
import peticion from '../utils/peticion';
import { meses } from '../../publico/utils/fecha';
import Cargando from '../../publico/components/cargando';
import Evento from './evento';
import Calendario from '../../publico/components/calendarios';
import NuevoEvento from './nuevoEvento';

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
        let mes = (month < 10  ? '0' : '') + month;
        let dia = (day < 10  ? '0' : '') + day;
        peticion('eventos','GET',{
            'dia' : year + '-' + mes + '-' + dia
        }).then(data => { 
            setEventos(data)
        })
        .catch(err => {
            alert("Ocurrió un error en el servidor")
        })
        .then(() => {
            setCargando(false)
        })
    }

    function obtenerFechas(year,month){
        let data = {
            'mes' : year + '-' + (month < 10 ? '0' : '') + month,
        }
        peticion('eventosmes','GET',data,true)
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
        <div className="card shadow p-3 mt-3">
            <Calendario fechas={fechas} clickDia={clickDia} cambioMes={cambioMes}/>
        </div>
        <div className="mt-3">
            <span className="d-block text-center h5 mb-3">Eventos {dia} de {meses[mes]}</span>
            <NuevoEvento 
                ano={ano}
                mes={mes}
                dia={dia}
                obtenerFechas={obtenerFechas}
                obtenerEventos={obtenerEventos}
            />
            {cargando ? <Cargando/>
            : <div>
                {eventos.length == 0 ? <div className="text-center text-muted">No hay eventos para este dia</div>
                : eventos.map(evento => (
                    <Evento
                    key={evento.idEventos}
                    id={evento.idEventos}
                    idUsuario={evento.idUsuario}
                    hora={evento.hora}
                    descripcion={evento.descripcion}
                    recargar={() => {
                        obtenerFechas(ano, mes + 1);
                        obtenerEventos(ano, mes, dia)
                    }}
                    />
                ))}
            </div>
            }
        </div>
    </div>

}

export default Eventos;