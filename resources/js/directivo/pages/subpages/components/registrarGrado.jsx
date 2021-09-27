import axios from 'axios';
import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { Link } from 'react-router-dom';
import SelectProfesor from './selectProfesor';

const RegistrarGrado = () => {

    const {register, handleSubmit, formState: {errors}} = useForm();
    const {director, setDirector} = useState(-1);
    const [idRegistrado, setIdRegistrado] = useState(0);
    const [nombreRegistrado, setNombreRegistrado] = useState('');
    const [cargando, setCargando] = useState(false);
    const [enRegistro, setEnRegistro] = useState(true);

    const onSubmit = (data) => {
        if(director != -1)
            data.director = director;

        setCargando(true);
        axios.post('/api/directivo/grupos/', data)
        .then(res => {
            setIdRegistrado(res.id);
            setNombreRegistrado(data.nombre);
            setEnRegistro(false);
        })
        .catch(err => {
            alert('Ocurrió un error');
        })
        .then(() => {
            setCargando(false);
        })
    }

    const reiniciar = () => {
        setEnRegistro(true);
    }

    if(!enRegistro)
        return <div className="d-flex justify-content-center align-items-center my-5 py-3">
            <img src="/images/notUser.jpg" className="rounded-circle mr-4" alt="register" height="80px"/>
            <div>
                <h3 className="h4 text-primary">Se agregó el grupo</h3>
                <p>El grupo <strong>{nombreRegistrado}</strong> fue registrado con exito.</p>
                <div className="flex justify-content-center">
                    <Link className="btn btn-primary mr-2 px-3 btn-sm" to={'/directivo/administrar/grados/ver/' + idRegistrado}>
                        <i className="fas fa-eye mr-2"></i>
                        Ver
                    </Link>
                    <button type="button" className="btn btn-secondary mr-2 px-3 btn-sm" onClick={reiniciar}>
                        <i className="fas fa-user-plus mr-2"></i>
                        Nuevo registro
                    </button>
                </div>
            </div>
        </div>
    else
        return <div>
            <h2 className="h5 pb-1">Registrar</h2>
            <form onSubmit={handleSubmit(onSubmit)}>
                <div className="form-row">
                    <div className="form-group col-2">
                        <label htmlFor="grado" className='text-muted small ml-2 mb-1'>Grado</label>
                        <input type="number" 
                            {...register('grado',{ required: true })}
                            min="0" max="15"
                            placeholder='Grado'
                            className={errors.grado ? 'form-control is-invalid' : 'form-control'} 
                            defaultValue="11"
                            id="grado" 
                        />
                        {errors.grado && <div className='invalid-feedback d-block'>El grado es requerido</div>}
                    </div>
                    <div className="form-group col-5">
                        <label htmlFor="nombre" className='text-muted small ml-2 mb-1'>Nombre</label>
                        <input type="text" 
                            {...register('nombre',{ required: true })}
                            maxLength="10"
                            placeholder='Ej: 11-01'
                            className={errors.nombre ? 'form-control is-invalid' : 'form-control'} 
                            id="nombre" 
                        />
                        {errors.nombre && <div className='invalid-feedback d-block'>El nombre es requerido</div>}
                    </div>
                    <div className="form-group col-5">
                        <label htmlFor="jornada" className='text-muted small ml-2 mb-1'>Jornada</label>
                        <select 
                            id="jornada"
                            {...register('jornada',{ required: true })}
                            defaultValue=""
                            className={errors.jornada ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option hidden value="">Seleccione...</option>
                            <option value="Mañana">Mañana</option>
                            <option value="Tarde">Tarde</option>
                            <option value="Nocturno">Nocturno</option>
                            <option value="Mixto">Mixto</option>
                        </select>
                        {errors.jornada && <div className='invalid-feedback d-block'>La jornada es requerida</div>}
                    </div>
                </div>
                <div className="form-row">
                    <div className="form-group col-6">
                        <label htmlFor="salon" className='text-muted small ml-2 mb-1'>Salón</label>
                        <input type="number" 
                            {...register('salon',{ required: true })}
                            maxLength="5"
                            defaultValue="0"
                            className={errors.salon ? 'form-control is-invalid' : 'form-control'} 
                            id="salon" 
                        />
                        {errors.salon && <div className='invalid-feedback d-block'>El salón es requerido</div>}
                    </div>
                    <div className="form-group col-6">
                        <label htmlFor="salon" className='text-muted small ml-2 mb-1'>Director de grupo</label>
                        <SelectProfesor setIdUsuario={setDirector} />
                        {errors.salon && <div className='invalid-feedback d-block'>El profesor es requerido</div>}
                    </div>
                </div>
                <div className="form-group text-center mt-3">
                    <button type="reset" className='btn btn-secondary mr-3'>
                        <i className="fas fa-eraser mr-2"></i>
                        Cancelar
                    </button>
                    <button type="submit" className='btn btn-primary px-4'>
                        <i className="fas fa-plus mr-2"></i>
                        Registrar
                    </button>
                </div>
            </form>
        </div>

}

export default RegistrarGrado;