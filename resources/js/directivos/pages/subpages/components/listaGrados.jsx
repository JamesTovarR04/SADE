import React, { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import Cargando from '../../../../publico/components/cargando';
import Paginacion from '../../../../publico/components/paginacion';
import ModalConfirmar from '../../../components/modalConfirmar';
import peticion from '../../../utils/peticion';

const ListaGrados = () => {

    const [grupos, setGrupos] = useState([]);
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
        cargarDirectivos(datos)
    },[orden,columna,page]);

    const cargarDirectivos = (datos) => {
        setCargando(true);
        peticion('grupos', 'GET', datos)
        .then(res => {
            if(res.data === undefined)
                setGrupos({data:res, total:res.length});
            else
                setGrupos(res);
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
        if(buscar.length > 0){
            let datos = {
                buscar: buscar
            }
            cargarDirectivos(datos);
            setContador(0);
        }
        
        if(event.target.value == ''){
            cargarDirectivos();
        }
    }

    function pagina(page){
        setPage(page)
        setContador((page - 1) * grupos.per_page)
    }

    const eliminar = () => {
        peticion('grupos/' + idEliminar ,'DELETE')
        .then(res => {
            const estud = grupos.data.filter(e => e.idGrupo !== idEliminar);
            setGrupos({...grupos, data: estud, total: (grupos.total-1)});
        })
        .catch(err => {
            alert('No se pudo eliminar')
        })
    }

    return <div>
        <div className="d-flex">
            <div className="flex-grow-1 d-flex">
                <Link to="/directivo/administrar/grados/registrar" className="btn btn-primary mr-2 px-3">
                    <i className="fas fa-plus mr-2"></i>
                    Nuevo Grado
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
                    <option value="jornada">Jornada</option>
                    <option value="salon">Salon</option>
                </select>
            </div>
        </div>
        <div className="border-bottom border-secondary pl-3 py-2">
            <strong>{grupos.total}</strong><span className="text-muted"> grupos</span>
        </div>
        { cargando ? <Cargando />
        :
        <div className="table-responsive" style={{height:'60vh'}}>
            <table className="table table-striped table-sm table-hover">
                <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">Grado</th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Jornada</th>
                        <th scope="col">Salón</th>
                        <th scope="col"></th>
                    </tr>
                </thead>
                <tbody>
                    { grupos.data !== undefined && grupos.data.map((grupo, index) => (
                        <tr key={grupo.idGrupo}>
                            <th>{(index + 1) + contador}</th>
                            <td>{grupo.grado}</td>
                            <td>
                                <Link className="text-decoration-none text-body"
                                    to={'/directivo/administrar/grupos/ver/' + grupo.idGrupo}
                                >
                                    {grupo.nombre}
                                </Link>
                            </td>
                            <td>{grupo.jornada}</td>
                            <td>{grupo.salon}</td>
                            <td>
                                <div className="d-flex">
                                    <Link 
                                        className="btn btn-success btn-sm py-0 mr-2"
                                        to={'/directivo/administrar/grupos/ver/' + grupo.idGrupo + '/edit'}
                                    >
                                        <i className="fas fa-edit"></i>
                                    </Link>
                                    <button 
                                        className="btn btn-danger py-0 btn-sm" 
                                        data-toggle="modal" 
                                        data-target="#deleteEst"
                                        onClick={() => {setNombreEliminar(grupo.nombre); setIdEliminar(grupo.idGrupo)}}
                                    >
                                        <i className="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
            <Paginacion pagina={pagina} last={grupos.last_page} current={grupos.current_page}/>
        </div>
        }
        <ModalConfirmar id="deleteEst" text={'¿Quieres eliminar a ' + nombreEliminar + '?'} eliminar={true} confirm={eliminar}/>
    </div>

}

export default ListaGrados;