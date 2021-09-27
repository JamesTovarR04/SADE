import axios from 'axios';
import React, { useState } from 'react';
import SelectSearch from 'react-select-search';

const SelectProfesor = (props) => {

    const [seleccion, setSeleccion] = useState('');
    var opciones = [];

    const seleccionar = (valor) => {
        let selec = opciones.filter(val => val.value === valor);
        setSeleccion(selec[0].name)
        props.setIdUsuario(valor);
    }

    const getOptions = (buscar) => {
        if(buscar.length > 4){
            return new Promise((resolve, reject) => {
                axios.get('/api/directivo/profesores', {
                    params: {buscar: buscar}
                })
                .then(res => {
                    let options = res.data.map(({ idUsuario, nombre }) => ({ value: idUsuario, name: nombre }))
                    if(res.length > 0){
                        opciones = options;
                    } 
                    resolve(options);
                })
                .catch(reject)
            });
        }else{
            return opciones;
        }
        
    }

    return <SelectSearch
        options={opciones}
        getOptions={getOptions}
        emptyMessage="No hay resultados"
        search
        onChange={seleccionar}
        placeholder={(seleccion == '') ? 'Buscar profesor...' : seleccion}
    />

}

export default SelectProfesor;