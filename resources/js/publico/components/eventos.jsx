import React, { useState } from 'react';
import Calendario from './calendarios';

const Eventos = () => {

    const [fechas,setFechas] = useState([]);

    function obtenerFechas(year,month){
        // TODO: Obtener fechas y enviarlas al componente calendario
    }

    function clickDia(year,month,day){
        // TODO: mostrar eventos dia
    }

    function cambioMes(year,month){
        obtenerFechas(year,month)
    }

    return <div className="my-3">
        <h2 className="h5"><i className="fas fa-calendar-alt mr-1"></i> Eventos</h2>
        <div className="card shadow p-3 mt-3"><Calendario fechas={fechas} clickDia={clickDia} cambioMes={cambioMes}/></div>
    </div>

}

export default Eventos;