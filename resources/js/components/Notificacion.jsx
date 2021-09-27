import React from 'react'
import PropTypes from 'prop-types'

import fecha from '../helpers/fecha'

const Notificacion = ({
    idNotificacion,
    texto,
    date,
    eliminar
}) => {

    const fEliminar = () => {
        eliminar(idNotificacion)
    }

    return <div className="card shadow mb-2" >
        <div className="card-body pt-3">
            <div className="d-flex mb-2">
                <div className="flex-grow-1">
                    <span className="ml-2 text-muted">{fecha(date, true)}</span>
                </div>
                <div className="text-muted">
                    <span onClick={fEliminar}>
                        <i className="fas fa-times" style={{cursor: "pointer"}}></i>
                    </span>
                </div>
            </div>
            <span>{texto}</span>
        </div>
    </div>
}

Notificacion.propTypes = {
    idNotificacion: PropTypes.number,
    texto: PropTypes.string,
    date: PropTypes.string,
    eliminar: PropTypes.func
}

export default Notificacion
