import React, { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { Link, useParams } from 'react-router-dom';
import Cargando from '../../../../publico/components/cargando';
import peticion from '../../../utils/peticion';
import tipoDocumento from '../../../utils/tipoDocumento';
import Telefonos from './telefonos';

/**
 * TODO: Descomponer en componentes mas pequeños
 * No esta validado si el correo ya existe
 */
const VerDirectivo = () => {

    let { id, option } = useParams();
    const { register, handleSubmit, errors, getValues, clearErrors, setError} = useForm();

    const [directivo, setDirectivo] = useState({});
    const [cargando, setCargando] = useState(true);
    const [editando, setEditando] = useState(option == "edit");

    useEffect(() => {
        cargarDatos();
    },[])

    const cargarDatos = () => {
        setCargando(true);
        peticion('directivos/' + id)
        .then(res => {
            setDirectivo(res);
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
        peticion('directivos/' + id, 'PUT', data)
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
                <div className="d-flex justify-content-center align-items-center">
                    <img src="/images/notUser.jpg" className="rounded-circle mr-5" alt={directivo.data.nombres} width="120px" height="120px"/>
                    <div style={{minWidth:"200px"}}>
                        <div className="form-group mb-1">
                            <label htmlFor="nombre" className="text-muted small mb-1">Nombres</label>
                            { editando ? 
                            <input type="text" 
                                name="nombres" 
                                ref={register({ required: true, minLength:3 })}
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
                            <div className="form-group col-6">
                                <label htmlFor="apellido1" className="text-muted small mb-1">Apellido 1</label>
                                { editando ? 
                                <input type="text" 
                                    name="apellido1" 
                                    ref={register({ required: true, minLength:3 })}
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
                            <div className="form-group col-6">
                                <label htmlFor="apellido2" className="text-muted small mb-1">Apellido 2</label>
                                { editando ? 
                                <input type="text" 
                                    name="apellido2" 
                                    ref={register({ required: false, minLength:3 })}
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
                <h2 className="h6"><i className="fas fa-paste mr-2 ml-3"></i> Cargo</h2>
                <div className="form-row">
                    <div className="form-group col-6">
                        <label htmlFor="cargo" className='text-muted small ml-2 mb-1'>Cargo</label>
                        { editando ? 
                        <input type="text" 
                            name="cargo" 
                            ref={register({ required: true })}
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
                    <div className="form-group col-6">
                        <label htmlFor="emailPublico" className='text-muted small ml-2 mb-1'>Email Público</label>
                        { editando ? 
                        <input type="email" 
                            name="emailPublico" 
                            ref={register({ required: true })}
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
                <h2 className="h6"><i className="fas fa-id-card mr-2 ml-3"></i> Documento de identidad</h2>
                <div className="form-row justify-content-center">
                    <div className="form-group col-3">
                        <label htmlFor="tipoDocumento" className='text-muted small ml-2 mb-1'>Tipo</label>
                        { editando ? 
                        <select 
                            name="tipoDocumento" 
                            id="tipoDocumento"
                            ref={register({ required: true })}
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
                    <div className="form-group col-3">
                        <label htmlFor="numeroDocumento" className='text-muted small ml-2 mb-1'>Numero</label>
                        { editando ? 
                        <input type="number" 
                            name="numeroDocumento" 
                            ref={register({ required: true })}
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
                    <div className="form-group col-3">
                        <label htmlFor="fechaExpedicion" className='text-muted small ml-2 mb-1'>Fecha Expedición</label>
                        { editando ? 
                        <input type="date" 
                            name="fechaExpedicion" 
                            ref={register({ required: true })}
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
                    <div className="form-group col-3">
                        <label htmlFor="lugarExpedicion" className='text-muted small ml-2 mb-1'>Lugar Expedición</label>
                        { editando ? 
                        <input type="text" 
                            name="lugarExpedicion" 
                            ref={register({ required: true })}
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
                <h2 className="h6"><i className="fas fa-user mr-2 ml-3"></i> Datos personales</h2>
                <div className="form-row justify-content-center">
                    <div className="form-group col-6">
                        <label htmlFor="sexo" className='text-muted small ml-2 mb-1'>Sexo</label>
                        { editando ? 
                        <select 
                            name="sexo" 
                            id="sexo"
                            ref={register({ required: true })}
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
                    <div className="form-group col-6">
                        <label htmlFor="fechaNacimiento" className='text-muted small ml-2 mb-1'>Fecha Nacimiento</label>
                        { editando ? 
                        <input type="date" 
                            name="fechaNacimiento" 
                            ref={register({ required: true })}
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
                <h2 className="h6"><i className="fas fa-phone mr-2 ml-3"></i> Datos de contacto</h2>
                <div className="form-row">
                    <div className="form-group col-3">
                        <label htmlFor="direccion" className='text-muted small ml-2 mb-1'>Direccion</label>
                        { editando ? 
                        <input type="text" 
                            name="direccion" 
                            ref={register({ required: true })}
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
                    <div className="form-group col-auto">
                        <label htmlFor="telefono" className='text-muted small ml-2 mb-1'>Telefonos</label>
                        <div className="d-block">
                            <Telefonos telefonos={directivo.telefonos}/>
                        </div>
                    </div>
                </div>
                <h2 className="h6"><i className="fas fa-database mr-2 ml-3"></i> Datos de usuario</h2>
                <div className="form-row">
                    <div className="form-group col-6">
                        <label htmlFor="email" className='text-muted small ml-2 mb-1'>E-mail</label>
                        { editando ? 
                        <input type="email" 
                            name="email" 
                            ref={register({ required: false })}
                            maxLength="45"
                            placeholder={directivo.data.email} 
                            className={errors.email ? 'form-control is-invalid' : 'form-control'} 
                            id="email" 
                        />
                        : <p className="my-1 font-weight-bolder">{directivo.data.email}</p>
                        }
                        {errors.email && <div className='invalid-feedback d-block'>La email es requerido</div>}
                    </div>
                    <div className="form-group col-auto">
                        <label htmlFor="fechaNacimiento" className='text-muted small ml-2 mb-1'>Fecha Registro</label>
                        <p className="my-1 font-weight-bolder">{directivo.data.fechaRegistro}</p>
                    </div>
                </div>
                { editando &&
                    <div className="form-row">
                        <div className="form-group col-6">
                            <label htmlFor="contrasena" className='text-muted small ml-2 mb-1'>Contraseña</label>
                            <input type="password" 
                                name="contrasena" 
                                ref={register({ required: false, minLength: 5 })}
                                maxLength="45"
                                placeholder="Contraseña" 
                                className={errors.contrasena ? 'form-control is-invalid' : 'form-control'} 
                                id="contrasena" 
                            />
                            {errors.contrasena && <div className='invalid-feedback d-block'>Contraseña invalida</div>}
                        </div>
                        <div className="form-group col-6">
                            <label htmlFor="confPassword" className='text-muted small ml-2 mb-1'>Confirmar contraseña</label>
                            <input type="password" 
                                name="confPassword" 
                                ref={register({ required: (getValues('contrasena') != ''), minLength: 5 })}
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