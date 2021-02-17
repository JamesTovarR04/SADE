import React from 'react'

const Cargando = () => {
    return (
        <div className="d-flex align-items-center justify-content-center" style={{minHeight:100+'px'}}>
                <div className="spinner-border text-info" role="status">
                    <span className="sr-only">Cargando...</span>
                </div>
        </div>
    )
}

export default Cargando;