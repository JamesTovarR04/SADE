import React, { useEffect, useState } from 'react'

import Calendario from '../../components/Calendario'
import Cargando from '../../components/Cargando';
import Evento from '../../components/Evento';
import { meses } from '../../helpers/fecha';
import useEventos from '../hooks/useEventos';

const Eventos = () => {

    const [fechas, clickDia, cambioMes, dia, mes, eventos, cargando, error] = useEventos()

    return (
    <>
       <h2 className="line-title text-primary"><i className="fas fa-calendar-alt mr-1"></i> Eventos</h2>
       <div className="mt-3 mb-4">
            <div className="card p-3 shadow">
                <Calendario fechas={fechas} clickDia={clickDia} cambioMes={cambioMes}/>
            </div>
            <div className="mt-4">
                <span className="d-block text-center h4 mb-3">Eventos {dia} de {meses[mes]}</span>
                {cargando ? <Cargando error={error}/>
                : <div>
                    {eventos.length == 0 ? <div className="text-center text-muted">No hay eventos para este día</div>
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
    </>
    )
}

export default Eventos
