import React, { useState } from 'react'

const ModalPrivacidad = (props) => {

    const [valores, setValores] = useState(props.privacidad);
    const [isPublico, setIsPublico] = useState(props.privacidad.publico)
    const [aprobado, setAprobado] = useState(true)

    const aceptar = () => {
        props.setPrivacidad(valores)
    }

    const handleInputChange = (event) => {
        if(event.target.name == "publico" && event.target.checked){
            setIsPublico(true);
            setValores({
                publico : true,
                estudiante : true,
                profesor : true,
                directivo :true
            })
        }else{
            setIsPublico(false);
            setValores({
                ...valores,
                [event.target.name] : event.target.checked
            })
        }
    }

    return <div className="modal fade"  data-backdrop="static" data-keyboard="false" tabIndex="-1" id={props.id} aria-labelledby={props.id + "Label"}>
        <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
                <div className="modal-header justify-content-center">
                    <h5 className="modal-title"><i className="fas fa-unlock-alt mr-2"></i> Privacidad</h5>
                </div>
                <div className="modal-body text-center">
                    <p>¿Quienes pueden ver esta publicación?</p>
                    {(props.onlyView) ?
                        valores.publico == 1 &&
                        <div className="d-inline-block mx-1">
                            <i className="fas fa-globe-americas mr-2"></i>
                            <span>Público</span>
                        </div>
                    :
                    <div className="form-check form-check-inline">
                        <input 
                        className="form-check-input" 
                        type="checkbox" 
                        id="inlineCheckbox1" 
                        value="option1" 
                        name="publico"
                        onChange={handleInputChange} 
                        checked={valores.publico}
                        />
                        <label className="form-check-label" htmlFor="inlineCheckbox1">Público</label>
                    </div>
                    }
                    {(props.onlyView) ?
                        valores.directivo == 1  &&
                        <div className="d-inline-block mx-1">
                            <i className="fas fa-user-tie mr-2"></i>
                            <span>Directivos</span>
                        </div>
                    :
                    <div className="form-check form-check-inline">
                        <input 
                            className="form-check-input" 
                            type="checkbox" id="inlineCheckbox2" 
                            value="option2" 
                            name="directivo"
                            onChange={handleInputChange} 
                            checked={valores.directivo}
                            disabled={isPublico}
                        />
                        <label className="form-check-label" htmlFor="inlineCheckbox2">Directivos</label>
                    </div>
                    }
                    {(props.onlyView) ?
                        valores.profesor == 1 &&
                        <div className="d-inline-block mx-1">
                            <i className="fas fa-user mr-2"></i>
                            <span>Profesores</span>
                        </div>
                    :
                    <div className="form-check form-check-inline">
                        <input 
                            className="form-check-input" 
                            type="checkbox" 
                            id="inlineCheckbox3" 
                            value="option3" 
                            name="profesor"
                            onChange={handleInputChange} 
                            checked={valores.profesor}
                            disabled={isPublico}
                        />
                        <label className="form-check-label" htmlFor="inlineCheckbox3">Profesores</label>
                    </div>
                    }
                    {(props.onlyView) ?
                        valores.estudiante == 1 &&
                        <div className="d-inline-block mx-1">
                            <i className="fas fa-user-graduate mr-2"></i>
                            <span>Estudiantes</span>
                        </div>
                    :
                    <div className="form-check form-check-inline">
                        <input 
                            className="form-check-input" 
                            type="checkbox" 
                            id="inlineCheckbox3" 
                            value="option3" 
                            name="estudiante"
                            onChange={handleInputChange} 
                            checked={valores.estudiante}
                            disabled={isPublico}
                        />
                        <label className="form-check-label" htmlFor="inlineCheckbox3">Estudiantes</label>
                    </div>
                    }
                </div>
                <div className="modal-footer">
                    <button type="button" className="btn btn-primary btn-sn" disabled={!aprobado} data-dismiss="modal" onClick={aceptar}>Aceptar</button>
                </div>
            </div>
        </div>
    </div>
}

export default ModalPrivacidad
