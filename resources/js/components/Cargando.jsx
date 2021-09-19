import React from 'react'
import propTypes from 'prop-types'

const Cargando = ({
    error = false
}) => {
    return (
        <div className="d-flex align-items-center justify-content-center" style={{minHeight:100+'px'}}>
            { error ?
            <div className="alert alert-danger" role="alert">
                <i className="fas fa-exclamation-triangle mr-2"></i> Ocurrió un error al cargar.
            </div>
            :
            <div className="spinner-border text-primary" role="status">
                <span className="sr-only">Cargando...</span>
            </div>
            }
        </div>
    )
}

Cargando.propTypes = {
    error: propTypes.bool
}

export default Cargando