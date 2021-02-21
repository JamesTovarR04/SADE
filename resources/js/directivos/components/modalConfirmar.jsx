import React from 'react';

const ModalConfirmar = (props) => {

    return <div className="modal fade" data-backdrop="static" data-keyboard="false" tabIndex="-1" id={props.id} aria-labelledby={props.id + "Label"}>
        <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
                <div className="modal-header justify-content-center">
                    <h5 className="modal-title">{props.text}</h5>
                </div>
                <div className="modal-footer justify-content-center">
                    <button type="button" className="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button 
                        type="button" 
                        className={"btn " + ((props.eliminar) ? "btn-danger" : "btn-primary")}
                        onClick={props.confirm}
                        data-dismiss="modal"
                    >
                        {props.eliminar ? "Eliminar" : "Aceptar"}
                    </button>
                </div>
            </div>
        </div>
    </div>
  

}

export default ModalConfirmar;