import React, { memo } from 'react'
import PropTypes from 'prop-types'

const ModalConfirmar = ({
    id = 0,
    texto = "¿Desea continuar?",
    eliminar = false,
    confirmar = () => {}
}) => {
    return <div className="modal fade" data-backdrop="static" data-keyboard="false" tabIndex="-1" id={id} aria-labelledby={id + "Label"}>
        <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
                <div className="modal-header justify-content-center">
                    <h3 className="modal-title text-body">{texto}</h3>
                </div>
                <div className="modal-footer justify-content-center">
                    <button type="button" className="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button 
                        type="button" 
                        className={"btn " + ((eliminar) ? "btn-danger" : "btn-primary")}
                        onClick={confirmar}
                        data-dismiss="modal"
                    >
                        {eliminar ? "Eliminar" : "Aceptar"}
                    </button>
                </div>
            </div>
        </div>
    </div>
}

ModalConfirmar.propTypes = {
    texto: PropTypes.string,
    eliminar: PropTypes.bool,
    confirmar: PropTypes.func,
    id: PropTypes.string
}

export default ModalConfirmar
