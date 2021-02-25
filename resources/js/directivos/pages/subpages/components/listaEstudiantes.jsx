import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import Cargando from '../../../../publico/components/cargando';
import Paginacion from '../../../../publico/components/paginacion';
import ModalConfirmar from '../../../components/modalConfirmar';
import peticion from '../../../utils/peticion';

const ListaEstudiantes = () => {

    const [estudiantes, setEstudiantes] = useState([]);
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
        cargarEstudiantes(datos)
    },[orden,columna,page]);

    const cargarEstudiantes = (datos) => {
        setCargando(true);
        peticion('estudiantes', 'GET', datos)
        .then(res => {
            if(res.data === undefined)
                setEstudiantes({data:res, total:res.length});
            else
                setEstudiantes(res);
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
            cargarEstudiantes(datos);
            setContador(0);
        }
        
        if(event.target.value == ''){
            cargarEstudiantes();
        }
    }

    function pagina(page){
        setPage(page)
        setContador((page - 1) * estudiantes.per_page)
    }

    const eliminar = () => {
        peticion('estudiantes/' + idEliminar ,'DELETE')
        .then(res => {
            const estud = estudiantes.data.filter(e => e.idUsuario !== idEliminar);
            setEstudiantes({...estudiantes, data: estud, total: (estudiantes.total-1)});

            
        })
        .catch(err => {
            alert('No se pudo eliminar')
        })
    }

    return <div>
        <div className="d-flex">
            <div className="flex-grow-1 d-flex">
                <Link to="/directivo/administrar/estudiantes/registrar" className="btn btn-primary mr-2 px-3">
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
                    <option value="nombreGrupo">Grupo</option>
                </select>
            </div>
        </div>
        <div className="border-bottom border-secondary pl-3 py-2">
            <strong>{estudiantes.total}</strong><span className="text-muted"> estudiantes</span>
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
                        <th scope="col">Grupo</th>
                        <th scope="col">Telefono</th>
                        <th scope="col"></th>
                    </tr>
                </thead>
                <tbody>
                    { estudiantes.data !== undefined && estudiantes.data.map((estudiante, index) => (
                        <tr key={estudiante.idUsuario}>
                            <th>{(index + 1) + contador}</th>
                            <td>
                                <Link className="text-decoration-none text-body"
                                    to={'/directivo/administrar/estudiantes/ver/' + estudiante.idUsuario}
                                >
                                    {estudiante.nombre}
                                </Link>
                            </td>
                            <td>{estudiante.email}</td>
                            <td>{estudiante.documentoIdentidad}</td>
                            <td><Link className="btn btn-primary btn-sm py-0 mr-2"
                                to={'/directivo/administrar/grados/grupo/' + estudiante.idGrupo}
                                >{estudiante.nombreGrupo}</Link>
                            </td>
                            <td>{estudiante.telefono}</td>
                            <td>
                                <div className="d-flex">
                                    <Link 
                                        className="btn btn-success btn-sm py-0 mr-2"
                                        to={'/directivo/administrar/estudiantes/ver/' + estudiante.idUsuario + '/edit'}
                                    >
                                        <i className="fas fa-edit"></i>
                                    </Link>
                                    <button 
                                        className="btn btn-danger py-0 btn-sm" 
                                        data-toggle="modal" 
                                        data-target="#deleteEst"
                                        onClick={() => {setNombreEliminar(estudiante.nombre); setIdEliminar(estudiante.idUsuario)}}
                                    >
                                        <i className="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
            <Paginacion pagina={pagina} last={estudiantes.last_page} current={estudiantes.current_page}/>
        </div>
        }
        <ModalConfirmar id="deleteEst" text={'¿Quieres eliminar a ' + nombreEliminar + '?'} eliminar={true} confirm={eliminar}/>
    </div>

}

export default ListaEstudiantes;