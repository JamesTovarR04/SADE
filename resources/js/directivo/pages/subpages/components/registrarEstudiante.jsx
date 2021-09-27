import axios from 'axios';
import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { Link } from 'react-router-dom';
import SelectGrupo from './selectGrupo';

const RegistrarEstudiante = () => {

    const { register, handleSubmit, formState: {errors}, getValues, clearErrors, setError} = useForm();

    const [grupo, setGrupo] = useState('');
    const [egresado, setEgresado] = useState(false);
    const [idRegistrado, setIdRegistrado] = useState(0);
    const [nombreRegistrado, setNombreRegistrado] = useState('');
    const [cargando, setCargando] = useState(false);
    const [enRegistro, setEnRegistro] = useState(true);

    const onSubmit = (data) => {
        if(data.apellido2 == '') delete data.apellido2;
        if(grupo != '') data.idGrupo = grupo;
        data.egresado = data.egresado ? 1 : 0;
        setCargando(true);
        axios.post('/api/directivo/estudiantes', data)
        .then(res => {
            setIdRegistrado(res.id);
            setNombreRegistrado(data.nombres + ' ' + data.apellido1);
            setEnRegistro(false);
        })
        .catch(res => {
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
                <h3 className="h4 text-primary">Usuario Registrado</h3>
                <p>El estudiante <strong>{nombreRegistrado}</strong> fue registrado con exito.</p>
                <div className="flex justify-content-center">
                    <Link className="btn btn-primary mr-2 px-3 btn-sm" to={'/directivo/administrar/estudiantes/ver/' + idRegistrado}>
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
            <h3 className="line-title text-primary pb-1">Registrar</h3>
            <form onSubmit={handleSubmit(onSubmit)}>
                <div className="d-flex justify-content-center align-items-center">
                    <img src="/images/notUser.jpg" className="rounded-circle mr-5" alt="Image-user" width="120px" height="120px"/>
                    <div style={{minWidth:"200px"}}>
                        <div className="form-group mb-1">
                            <label htmlFor="nombre" className="text-muted small mb-1">Nombres</label>
                            <input type="text" 
                                {...register('nombres',{ required: true, minLength:3 })}
                                maxLength="60"
                                placeholder='Nombres'
                                className={errors.nombres ? 'form-control is-invalid' : 'form-control'} 
                                id="nombre" 
                            />
                            {errors.nombres && <div className='invalid-feedback d-block'>El nombre es requerido</div>}
                        </div>
                        <div className="form-row">
                            <div className="form-group col-md-6">
                                <label htmlFor="apellido1" className="text-muted small mb-1">Apellido 1</label>
                                <input type="text" 
                                    {...register('apellido1',{ required: true, minLength:3 })}
                                    maxLength="45"
                                    placeholder='Apellido 1'
                                    className={errors.apellido1 ? 'form-control is-invalid' : 'form-control'} 
                                    id="apellido1" 
                                />
                                {errors.apellido1 && <div className='invalid-feedback d-block'>El primer apellido es requerido</div>}
                            </div>
                            <div className="form-group col-md-6">
                                <label htmlFor="apellido2" className="text-muted small mb-1">Apellido 2</label>
                                <input type="text" 
                                    {...register('apellido2',{ required: false, minLength:3 })}
                                    maxLength="45"
                                    placeholder='Apellido 2'
                                    className={errors.apellido2 ? 'form-control is-invalid' : 'form-control'} 
                                    id="apellido2" 
                                />
                                {errors.apellido2 && <div className='invalid-feedback d-block'>El primer apellido es requerido</div>}
                            </div>
                        </div>
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-cube mr-2 ml-3"></i> Información de Grado</h3>
                <div className="form-row">
                    <div className="form-group col-md-1 text-center">
                        <label htmlFor="egresado" className='text-muted small mb-1'>Egresado</label>
                        <div className="form-check">
                            <input 
                                {...register('egresado',{ required: false })} 
                                className="form-check-input mt-2" 
                                type="checkbox" 
                                id="egresado" 
                                onClick={e => {setEgresado(e.target.checked)}}
                            />
                        </div>
                    </div>
                    <div className="form-group col-md-auto">
                        <SelectGrupo
                            disabled={egresado}
                            setGrupo={setGrupo}
                        />
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-id-card mr-2 ml-3"></i> Documento de identidad</h3>
                <div className="form-row justify-content-center">
                    <div className="form-group col-md-3">
                        <label htmlFor="tipoDocumento" className='text-muted small ml-2 mb-1'>Tipo</label>
                        <select 
                            id="tipoDocumento"
                            {...register('tipoDocumento',{ required: true })}
                            defaultValue=""
                            className={errors.tipoDocumento ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option hidden value="">Seleccione...</option>
                            <option value="CC">Cédula de ciudadanía</option>
                            <option value="CE">Cédula de extranjería</option>
                            <option value="RC">Registro Civil</option>
                            <option value="TI">Tarjeta de identidad</option>
                        </select>
                        {errors.tipoDocumento && <div className='invalid-feedback d-block'>El tipo de documento es requerido</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="numeroDocumento" className='text-muted small ml-2 mb-1'>Numero</label>
                        <input type="number" 
                            {...register('numeroDocumento',{ required: true })}
                            maxLength="15"
                            placeholder='Número de documento'
                            className={errors.numeroDocumento ? 'form-control is-invalid' : 'form-control'} 
                            id="numeroDocumento" 
                        />
                        {errors.numeroDocumento && <div className='invalid-feedback d-block'>El número es requerido</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="fechaExpedicion" className='text-muted small ml-2 mb-1'>Fecha Expedición</label>
                        <input type="date" 
                            {...register('fechaExpedicion',{ required: true })}
                            maxLength="15"
                            placeholder='AAAA-MM-DD'
                            className={errors.fechaExpedicion ? 'form-control is-invalid' : 'form-control'} 
                            id="fechaExpedicion" 
                        />
                        {errors.fechaExpedicion && <div className='invalid-feedback d-block'>La fecha es requerida</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="lugarExpedicion" className='text-muted small ml-2 mb-1'>Lugar Expedición</label>
                        <input type="text" 
                            {...register('lugarExpedicion',{ required: true })}
                            maxLength="45"
                            placeholder='Lugar de expedición'
                            className={errors.lugarExpedicion ? 'form-control is-invalid' : 'form-control'} 
                            id="lugarExpedicion" 
                        />
                        {errors.lugarExpedicion && <div className='invalid-feedback d-block'>El lugar es requerido</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-user mr-2 ml-3"></i> Datos personales</h3>
                <div className="form-row justify-content-center">
                    <div className="form-group col-md-4">
                        <label htmlFor="sexo" className='text-muted small ml-2 mb-1'>Sexo</label>
                        <select 
                            id="sexo"
                            {...register('sexo',{ required: true })}
                            defaultValue=""
                            className={errors.sexo ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option value="" hidden>Seleccione...</option>
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                        </select>
                        {errors.sexo && <div className='invalid-feedback d-block'>El sexo es requerido</div>}
                    </div>
                    <div className="form-group col-md-4">
                        <label htmlFor="fechaNacimiento" className='text-muted small ml-2 mb-1'>Fecha Nacimiento</label>
                        <input type="date" 
                            {...register('fechaNacimiento',{ required: true })}
                            maxLength="15"
                            placeholder='AAAA-MM-DD'
                            className={errors.fechaNacimiento ? 'form-control is-invalid' : 'form-control'} 
                            id="fechaNacimiento" 
                        />
                        {errors.fechaNacimiento && <div className='invalid-feedback d-block'>La fecha es requerida</div>}
                    </div>
                    <div className="form-group col-md-4">
                        <label htmlFor="rh" className='text-muted small ml-2 mb-1'>RH (Tipo de sangre)</label>
                        <select 
                            id="rh"
                            {...register('rh',{ required: true })}
                            defaultValue=""
                            className={errors.rh ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option value="" hidden>Seleccione...</option>
                            <option value="0+">0+</option>
                            <option value="0-">0-</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                        </select>
                        {errors.rh && <div className='invalid-feedback d-block'>El tipo de sangre es requerido</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-phone mr-2 ml-3"></i> Datos de contacto</h3>
                <div className="form-row">
                    <div className="form-group col-md-3">
                        <label htmlFor="direccion" className='text-muted small ml-2 mb-1'>Direccion</label>
                        <input type="text" 
                            {...register('direccion',{ required: true })}
                            maxLength="45"
                            placeholder='Ej: Calle N #0-00'
                            className={errors.direccion ? 'form-control is-invalid' : 'form-control'} 
                            id="direccion" 
                        />
                        {errors.direccion && <div className='invalid-feedback d-block'>La direccion es requerida</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-database mr-2 ml-3"></i> Datos de usuario</h3>
                <div className="form-row">
                    <div className="form-group col-md-12">
                        <label htmlFor="email" className='text-muted small ml-2 mb-1'>E-mail</label>
                        <input type="email" 
                            {...register('email',{ required: true })}
                            maxLength="45"
                            placeholder="email"
                            className={errors.email ? 'form-control is-invalid' : 'form-control'} 
                            id="email" 
                        />
                        {errors.email && <div className='invalid-feedback d-block'>El email es requerido</div>}
                    </div>
                </div>
                <div className="form-row">
                    <div className="form-group col-md-6">
                        <label htmlFor="contrasena" className='text-muted small ml-2 mb-1'>Contraseña</label>
                        <input type="password" 
                            {...register('contrasena',{ required: true, minLength: 5 })}
                            maxLength="45"
                            placeholder="Contraseña" 
                            className={errors.contrasena ? 'form-control is-invalid' : 'form-control'} 
                            id="contrasena" 
                        />
                        {errors.contrasena && <div className='invalid-feedback d-block'>Contraseña invalida</div>}
                    </div>
                    <div className="form-group col-md-6">
                        <label htmlFor="confPassword" className='text-muted small ml-2 mb-1'>Confirmar contraseña</label>
                        <input type="password" 
                            {...register('confPassword',{ required: (getValues('contrasena') != ''), minLength: 5 })}
                            maxLength="25"
                            placeholder="Confirmar Contraseña" 
                            className={errors.noPass ? 'form-control is-invalid' : 'form-control'} 
                            id="password" 
                            onChange={e => {
                                const pass = getValues('contrasena');
                                if(e.target.value === pass){
                                    clearErrors('noPass')
                                }else{
                                    setError('noPass','No Coinciden')
                                }
                            }}
                        />
                        {errors.noPass && <div className='invalid-feedback d-block'>No Coinciden las contraseñas</div>}
                    </div>
                </div>
                <div className="form-group text-center mt-3">
                    <button type="reset" className='btn btn-secondary mr-3'>
                        <i className="fas fa-eraser mr-2"></i>
                        Cancelar
                    </button>
                    <button type="submit" className='btn btn-primary px-4'>
                        <i className="fas fa-user-plus mr-2"></i>
                        Registrar
                    </button>
                </div>
            </form>
        </div>

}

export default RegistrarEstudiante;