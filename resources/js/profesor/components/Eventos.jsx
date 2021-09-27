import React from 'react'
import useEventos from '../../hooks/useEventos'
import Calendario from '../../components/Calendario'
import Cargando from '../../components/Cargando';
import Evento from '../../components/Evento';
import { meses } from '../../helpers/fecha';
import NuevoEvento from '../../components/NuevoEvento';

const Eventos = () => {

    const [fechas, clickDia, cambioMes, dia, mes, ano, eventos, cargando, error, obtenerEventos, obtenerFechas] = useEventos('profesor')
    
    const recargar = () => {
        obtenerEventos(ano, mes, dia);
        obtenerFechas(ano, mes + 1);
    }

    return (
        <>
       <h2 className="line-title text-primary"><i className="fas fa-calendar-alt mr-1"></i> Eventos</h2>
       <div className="mt-3 mb-4">
            <div className="card p-3 shadow">
                <Calendario fechas={fechas} clickDia={clickDia} cambioMes={cambioMes}/>
            </div>
            <div className="mt-4">
                <span className="d-block text-center h4 mb-3">Eventos {dia} de {meses[mes]}</span>
                <NuevoEvento 
                ano={ano}
                mes={mes}
                dia={dia}
                recargar={recargar}/>
                {cargando ? <Cargando error={error}/>
                : <div>
                    {eventos.length == 0 ? <div className="text-center text-muted">No hay eventos para este día</div>
                    : eventos.map(evento => (
                        <Evento
                        key={evento.idEventos}
                        hora={evento.hora}
                        descripcion={evento.descripcion}
                        idUsuario={evento.idUsuario}
                        idEvento={evento.idEventos}
                        recargar={recargar}
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
