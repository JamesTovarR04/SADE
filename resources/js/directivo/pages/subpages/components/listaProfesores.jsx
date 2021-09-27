import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import Cargando from '../../../../components/Cargando';
import Paginacion from '../../../../components/Paginacion';
import ModalConfirmar from '../../../../components/Modales/ModalConfirmar';

const ListaProfesores = () => {

    const [profesores, setProfesores] = useState([]);
    const [cargando,setCargando] = useState(true);
    const [page, setPage] = useState(1);
    const [orden, setOrden] = useState('asc');
    const [columna, setColumna] = useState('');
    const [buscar, setBuscar] = useState('');
    const [contador, setContador] = useState(0);
    const [nombreEliminar, setNombreEliminar] = useState('');
    const [idEliminar, setIdEliminar] = useState(0);

    useEffect(() => {
        let datos = {
            orden: orden,
            colorden: columna,
            page: page,
        }
        cargarProfesores(datos)
    },[orden,columna,page]);

    const cargarProfesores = (datos) => {
        setCargando(true);
        axios.get('/api/directivo/profesores/', {
            params: datos
        })
        .then(({ data }) => {
            if(data.data === undefined)
                setProfesores({data:data, total:data.length});
            else
                setProfesores(data);
        })
        .catch(err => {
            //
        })
        .then(() => {
            setCargando(false)
        })
    }

    const buscarChange = (event) => {
        setBuscar(event.target.value);
        if(buscar.length > 3){
            let datos = {
                buscar: buscar
            }
            cargarProfesores(datos);
            setContador(0);
        }
        
        if(event.target.value == ''){
            cargarProfesores();
        }
    }

    function pagina(page){
        setPage(page)
        setContador((page - 1) * profesores.per_page)
    }

    const eliminar = () => {
        axios.delete('/api/directivo/profesores/' + idEliminar)
        .then(res => {
            const estud = profesores.data.filter(e => e.idUsuario !== idEliminar);
            setProfesores({...profesores, data: estud, total: (profesores.total-1)});
        })
        .catch(err => {
            alert('No se pudo eliminar')
        })
    }

    return <div>
        <div className="d-flex">
            <div className="flex-grow-1 d-flex">
                <Link to="/directivo/administrar/profesores/registrar" className="btn btn-primary mr-2 px-3">
                    <i className="fas fa-user-plus mr-2"></i>
                    Registrar
                </Link>
                <div className="input-group" style={{maxWidth:"300px"}}>
                    <div className="input-group-prepend">
                        <div className="input-group-text">
                            <i className="fas fa-search"></i>
                        </div>
                    </div>
                    <input 
                        type="text" 
                        className="form-control" 
                        id="inlineFormInputGroupUsername" 
                        placeholder="Buscar"
                        onChange={buscarChange}
                        value={buscar}
                    />
                </div>
            </div>
            <div className="d-flex">
                <div className="form-check form-check-inline">
                    <input 
                        className="form-check-input" 
                        onChange={() => setOrden('asc')} 
                        type="radio" name="orden" 
                        value="asc" 
                        defaultChecked
                    />
                    <label className="form-check-label" htmlFor="inlineRadio1"><i className="fas fa-sort-alpha-down"></i></label>
                </div>
                <div className="form-check form-check-inline">
                    <input 
                        className="form-check-input" 
                        onChange={() => setOrden('desc')} 
                        type="radio" 
                        name="orden" 
                        value="desc"
                    />
                    <label className="form-check-label" htmlFor="inlineRadio2"><i className="fas fa-sort-alpha-down-alt"></i></label>
                </div>
                <select className="custom-select mr-sm-2" id="inlineFormCustomSelect" onChange={(e) => setColumna(e.target.value)}>
                    <option value="" defaultValue>Orden...</option>
                    <option value="nombre">Nombre</option>
                    <option value="documentoIdentidad">Número de documento</option>
                    <option value="perfilAcademico">Perfil</option>
                </select>
            </div>
        </div>
        <div className="border-bottom border-secondary pl-3 py-2">
            <strong>{profesores.total}</strong><span className="text-muted"> profesores</span>
        </div>
        { cargando ? <Cargando />
        :
        <div className="table-responsive" style={{height:'60vh'}}>
            <table className="table table-striped table-sm table-hover">
                <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Email</th>
                        <th scope="col">Doc. Identidad</th>
                        <th scope="col">Perfil</th>
                        <th scope="col">Telefono</th>
                        <th scope="col"></th>
                    </tr>
                </thead>
                <tbody>
                    { profesores.data !== undefined && profesores.data.map((profesor, index) => (
                        <tr key={profesor.idUsuario}>
                            <th>{(index + 1) + contador}</th>
                            <td>
                                <Link className="text-decoration-none text-body"
                                    to={'/directivo/administrar/profesores/ver/' + profesor.idUsuario}
                                >
                                    {profesor.nombre}
                                </Link>
                            </td>
                            <td>{profesor.email}</td>
                            <td>{profesor.documentoIdentidad}</td>
                            <td>{(profesor.perfilAcademico).substr(0,10) + '...'}</td>
                            <td>{profesor.telefono}</td>
                            <td>
                                <div className="d-flex">
                                    <Link 
                                        className="btn btn-success btn-sm py-0 mr-2"
                                        to={'/directivo/administrar/profesores/ver/' + profesor.idUsuario + '/edit'}
                                    >
                                        <i className="fas fa-edit"></i>
                                    </Link>
                                    <button 
                                        className="btn btn-danger py-0 btn-sm" 
                                        data-toggle="modal" 
                                        data-target="#deleteEst"
                                        onClick={() => {setNombreEliminar(profesor.nombre); setIdEliminar(profesor.idUsuario)}}
                                    >
                                        <i className="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
            <Paginacion pagina={pagina} last={profesores.last_page} current={profesores.current_page}/>
        </div>
        }
        <ModalConfirmar id="deleteEst" text={'¿Quieres eliminar a ' + nombreEliminar + '?'} eliminar={true} confirmar={eliminar}/>
    </div>

}

export default ListaProfesores;