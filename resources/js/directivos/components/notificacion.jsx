import React from 'react';
import fecha from '../../publico/utils/fecha';

const Notificacion = (props) => {

    const eliminar = () => {
        props.eliminar(props.id)
    }

    return <div className="card shadow mb-2" style={{borderRadius: "20px"}}>
        <div className="card-body pt-3">
            <div className="d-flex mb-2">
                <div className="flex-grow-1">
                    <span className="ml-2 text-muted">{fecha(props.fecha, true)}</span>
                </div>
                <div className="text-muted">
                    <i className="fas fa-times" style={{cursor: "pointer"}} onClick={eliminar}></i>
                </div>
            </div>
            <span>{props.descripcion}</span>
        </div>
    </div>

}

export default Notificacion;