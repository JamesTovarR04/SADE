import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { useParams } from 'react-router-dom';
import Cargando from '../../../../components/Cargando';
import tipoDocumento from '../../../../helpers/tipoDocumento';
import Telefonos from './telefonos';

/**
 * TODO: Descomponer en componentes mas pequeños
 * No esta validado si el correo ya existe
 */
const VerDirectivo = () => {

    let { id, option } = useParams();
    const { register, handleSubmit, formState: {errors}, getValues, clearErrors, setError} = useForm();

    const [directivo, setDirectivo] = useState({});
    const [cargando, setCargando] = useState(true);
    const [editando, setEditando] = useState(option == "edit");

    useEffect(() => {
        cargarDatos();
    },[])

    const cargarDatos = () => {
        setCargando(true);
        axios.get('/api/directivo/directivos/' + id)
        .then(res => {
            setDirectivo(res.data);
        })
        .catch(err => {
            alert('Error al actualizar los datos')
        })
        .then(() => {
            setCargando(false);
        })
    }

    const onSubmit = (data) => {
        if(data.contrasena == '') delete data.contrasena;
        if(data.email == '') delete data.email;
        if(data.apellido2 == '') delete data.apellido2;
        axios.put('/api/directivo/directivos/' + id, data)
        .then(res => {
            cargarDatos();
            setEditando(false);
        })
        .catch(err => {
            alert('error al actualizar los datos')
        })
        .then(() => {
            //
        })
    }

    return <div>
        { cargando ? <Cargando />
        : directivo.data !== undefined &&
            <form onSubmit={handleSubmit(onSubmit)}>
                <div className="row justify-content-center align-items-center">
                    <div className="col-md-auto text-center">
                        <img src="/images/notUser.jpg" className="rounded-circle mr-5" alt={directivo.data.nombres} width="120px" height="120px"/>
                    </div>
                    <div className="col-md-auto">
                        <div className="form-group mb-1">
                            <label htmlFor="nombre" className="text-muted small mb-1">Nombres</label>
                            { editando ? 
                            <input type="text" 
                                {...register('nombres',{ required: true, minLength:3 })}
                                maxLength="60"
                                placeholder='Nombres'
                                className={errors.nombres ? 'form-control is-invalid' : 'form-control'} 
                                id="nombre" 
                                defaultValue={directivo.data.nombres} 
                            />
                            : <p className="my-1 font-weight-bolder">{directivo.data.nombres}</p>
                            }
                            {errors.nombres && <div className='invalid-feedback d-block'>El nombre es requerido</div>}
                        </div>
                        <div className="form-row">
                            <div className="form-group col-md-6">
                                <label htmlFor="apellido1" className="text-muted small mb-1">Apellido 1</label>
                                { editando ? 
                                <input type="text" 
                                    {...register('apellido1',{ required: true, minLength:3 })}
                                    maxLength="45"
                                    placeholder='Apellido 1'
                                    className={errors.apellido1 ? 'form-control is-invalid' : 'form-control'} 
                                    id="apellido1" 
                                    defaultValue={directivo.data.apellido1} 
                                />
                                : <p className="my-1 font-weight-bolder">{directivo.data.apellido1}</p>
                                }
                                {errors.apellido1 && <div className='invalid-feedback d-block'>El primer apellido es requerido</div>}
                            </div>
                            <div className="form-group col-md-6">
                                <label htmlFor="apellido2" className="text-muted small mb-1">Apellido 2</label>
                                { editando ? 
                                <input type="text" 
                                    name="apellido2" 
                                    {...register('apellido2',{ required: false, minLength:3 })}
                                    maxLength="45"
                                    placeholder='Apellido 2'
                                    className={errors.apellido2 ? 'form-control is-invalid' : 'form-control'} 
                                    id="apellido2" 
                                    defaultValue={directivo.data.apellido2} 
                                />
                                : <p className="my-1 font-weight-bolder">{directivo.data.apellido2}</p>
                                }
                                {errors.apellido2 && <div className='invalid-feedback d-block'>El primer apellido es requerido</div>}
                            </div>
                        </div>
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-paste mr-2 ml-3"></i> Cargo</h3>
                <div className="form-row">
                    <div className="form-group col-md-6">
                        <label htmlFor="cargo" className='text-muted small ml-2 mb-1'>Cargo</label>
                        { editando ? 
                        <input type="text" 
                            {...register('cargo',{ required: true })}
                            maxLength="255"
                            placeholder='Ej: Coordinador en sede...'
                            className={errors.cargo ? 'form-control is-invalid' : 'form-control'} 
                            id="cargo" 
                            defaultValue={directivo.data.cargo} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.cargo}</p>
                        }
                        {errors.cargo && <div className='invalid-feedback d-block'>El cargo es requerido</div>}
                    </div>
                    <div className="form-group col-md-6">
                        <label htmlFor="emailPublico" className='text-muted small ml-2 mb-1'>Email Público</label>
                        { editando ? 
                        <input type="email" 
                            {...register('emailPublica',{ required: true })}
                            maxLength="255"
                            placeholder='example@gmail.com'
                            className={errors.emailPublico ? 'form-control is-invalid' : 'form-control'} 
                            id="emailPublico" 
                            defaultValue={directivo.data.emailPublico} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.emailPublico}</p>
                        }
                        {errors.emailPublico && <div className='invalid-feedback d-block'>El email publico es requerido</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-id-card mr-2 ml-3"></i> Documento de identidad</h3>
                <div className="form-row justify-content-center">
                    <div className="form-group col-md-3">
                        <label htmlFor="tipoDocumento" className='text-muted small ml-2 mb-1'>Tipo</label>
                        { editando ? 
                        <select 
                            id="tipoDocumento"
                            {...register('tipoDocumento',{ required: true })}
                            defaultValue={directivo.data.tipoDocumento} 
                            className={errors.tipoDocumento ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option value="CC">Cédula de ciudadanía</option>
                            <option value="CE">Cédula de extranjería</option>
                            <option value="RC">Registro Civil</option>
                            <option value="TI">Tarjeta de identidad</option>
                        </select>
                        : <p className="my-1 font-weight-bolder">{tipoDocumento(directivo.data.tipoDocumento)}</p>
                        }
                        {errors.tipoDocumento && <div className='invalid-feedback d-block'>El tipo de documento es requerido</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="numeroDocumento" className='text-muted small ml-2 mb-1'>Numero</label>
                        { editando ? 
                        <input type="number" 
                            {...register('numeroDocument',{ required: true })}
                            maxLength="15"
                            placeholder='Número de documento'
                            className={errors.numeroDocumento ? 'form-control is-invalid' : 'form-control'} 
                            id="numeroDocumento" 
                            defaultValue={directivo.data.numero} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.numero}</p>
                        }
                        {errors.numeroDocumento && <div className='invalid-feedback d-block'>El número es requerido</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="fechaExpedicion" className='text-muted small ml-2 mb-1'>Fecha Expedición</label>
                        { editando ? 
                        <input type="date" 
                            {...register('frchaExpedicion',{ required: true })}
                            maxLength="15"
                            placeholder='AAAA-MM-DD'
                            className={errors.fechaExpedicion ? 'form-control is-invalid' : 'form-control'} 
                            id="fechaExpedicion" 
                            defaultValue={directivo.data.fechaExpedicion} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.fechaExpedicion}</p>
                        }
                        {errors.fechaExpedicion && <div className='invalid-feedback d-block'>La fecha es requerida</div>}
                    </div>
                    <div className="form-group col-md-3">
                        <label htmlFor="lugarExpedicion" className='text-muted small ml-2 mb-1'>Lugar Expedición</label>
                        { editando ? 
                        <input type="text" 
                            {...register('lugarExpedicion',{ required: true })}
                            maxLength="45"
                            placeholder='Lugar de expedición'
                            className={errors.lugarExpedicion ? 'form-control is-invalid' : 'form-control'} 
                            id="lugarExpedicion" 
                            defaultValue={directivo.data.lugarExpedicion} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.lugarExpedicion}</p>
                        }
                        {errors.lugarExpedicion && <div className='invalid-feedback d-block'>El lugar es requerido</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-user mr-2 ml-3"></i> Datos personales</h3>
                <div className="form-row justify-content-center">
                    <div className="form-group col-md-6">
                        <label htmlFor="sexo" className='text-muted small ml-2 mb-1'>Sexo</label>
                        { editando ? 
                        <select 
                            id="sexo"
                            {...register('sexo',{ required: true })}
                            defaultValue={directivo.data.sexo} 
                            className={errors.sexo ? 'form-control custom-select is-invalid' : 'custom-select form-control'} 
                        >
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                        </select>
                        : <p className="my-1 font-weight-bolder">{directivo.data.sexo == "M" ? 'Masculino' : 'Femenino'}</p>
                        }
                        {errors.sexo && <div className='invalid-feedback d-block'>El sexo es requerido</div>}
                    </div>
                    <div className="form-group col-md-6">
                        <label htmlFor="fechaNacimiento" className='text-muted small ml-2 mb-1'>Fecha Nacimiento</label>
                        { editando ? 
                        <input type="date" 
                            {...register('fechaNacimiento',{ required: true })}
                            maxLength="15"
                            placeholder='AAAA-MM-DD'
                            className={errors.fechaNacimiento ? 'form-control is-invalid' : 'form-control'} 
                            id="fechaNacimiento" 
                            defaultValue={directivo.data.fechaNacimiento} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.fechaNacimiento}</p>
                        }
                        {errors.fechaNacimiento && <div className='invalid-feedback d-block'>La fecha es requerida</div>}
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-phone mr-2 ml-3"></i> Datos de contacto</h3>
                <div className="form-row">
                    <div className="form-group col-md-3">
                        <label htmlFor="direccion" className='text-muted small ml-2 mb-1'>Direccion</label>
                        { editando ? 
                        <input type="text" 
                            {...register('direccion',{ required: true })}
                            maxLength="45"
                            placeholder='Ej: Calle N #0-00'
                            className={errors.direccion ? 'form-control is-invalid' : 'form-control'} 
                            id="direccion" 
                            defaultValue={directivo.data.direccion} 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.direccion}</p>
                        }
                        {errors.direccion && <div className='invalid-feedback d-block'>La direccion es requerida</div>}
                    </div>
                    <div className="form-group col-md-auto">
                        <label htmlFor="telefono" className='text-muted small ml-2 mb-1'>Telefonos</label>
                        <div className="d-block">
                            <Telefonos telefonos={directivo.telefonos}/>
                        </div>
                    </div>
                </div>
                <h3 className="line-title text-primary"><i className="fas fa-database mr-2 ml-3"></i> Datos de usuario</h3>
                <div className="form-row">
                    <div className="form-group col-md-6">
                        <label htmlFor="email" className='text-muted small ml-2 mb-1'>E-mail</label>
                        { editando ? 
                        <input type="email" 
                            {...register('email',{ required: false })}
                            maxLength="45"
                            placeholder={directivo.data.email} 
                            className={errors.email ? 'form-control is-invalid' : 'form-control'} 
                            id="email" 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.email}</p>
                        }
                        {errors.email && <div className='invalid-feedback d-block'>La email es requerido</div>}
                    </div>
                    <div className="form-group col-md-auto">
                        <label htmlFor="fechaNacimiento" className='text-muted small ml-2 mb-1'>Fecha Registro</label>
                        <p className="my-1 font-weight-bolder">{directivo.data.fechaRegistro}</p>
                    </div>
                </div>
                { editando &&
                    <div className="form-row">
                        <div className="form-group col-md-6">
                            <label htmlFor="contrasena" className='text-muted small ml-2 mb-1'>Contraseña</label>
                            <input type="password" 
                                {...register('contrasena',{ required: false, minLength: 5 })}
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
                }
                <div className="form-group text-center mt-3">
                    { editando ?
                        <div className=''>
                            <button type="reset" className='btn btn-secondary mr-3' onClick={() => setEditando(false)}>
                                <i className="fas fa-eraser mr-2"></i>
                                Cancelar
                            </button>
                            <button type="submit" className='btn btn-primary px-4'>
                                <i className="fas fa-edit mr-2"></i>
                                Actualizar
                            </button>
                        </div>
                    :
                    <button type="submit" className='btn btn-primary px-4' onClick={() => setEditando(true)}>
                        <i className="fas fa-edit mr-2"></i>
                        Editar datos
                    </button>
                    }
                </div>
            </form>
        }
    </div>

}

export default VerDirectivo;