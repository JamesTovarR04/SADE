import React, { useEffect, useState } from 'react';
import peticion from '../../../utils/peticion';

const SelectGrupo = (props) => {

    const [grupos, setGrupos] = useState([]);
    const [grado, setGrado] = useState(props.grado == undefined ? 11 : props.grado);
    const [grupo, setGrupo] = useState(props.grupo == undefined ? '' : props.grupo);

    useEffect(() => {
        let data = { grado : grado };
        peticion('grupos','GET', data)
        .then(res => {
            setGrupos(res);
        })
        .catch(err => {
            setGrupos([]);
        })
        .then(() => {

        })
    },[grado])

    const selectGrupo = (event) => {
        let grp = event.target.value;
        setGrupo(grp)
        if(props.setGrupo !== undefined)
            props.setGrupo(grp);
    }

    return <div className="form-row">
        <div className="col-3">
            <label htmlFor="tipoDocumento" className='text-muted small mb-1 ml-2'>Grado</label>
            <input 
                type="number" 
                max="11"
                min="0"
                value={grado}
                onChange={e => {setGrado(e.target.value)}}
                className="form-control"
                disabled={props.disabled}
            />
        </div>
        <div className="col-auto">
            <label htmlFor="tipoDocumento" className='text-muted small mb-1 ml-2'>Grupo</label>
            <select 
                className="custom-select mr-sm-2" 
                id="inlineFormCustomSelect" 
                onChange={selectGrupo}
                value={grupo}
                disabled={props.disabled}
            >
                { grupos.length == 0 ?
                    <option hidden value=''>No hay grupos</option>
                :
                    <option hidden value=''>Grupos...</option>
                }
                { grupos.map(g=> (
                    <option key={g.idGrupo} value={g.idGrupo}>{g.nombre} - ({g.jornada})</option>
                ))}
            </select>
        </div>
    </div>

}

export default SelectGrupo;