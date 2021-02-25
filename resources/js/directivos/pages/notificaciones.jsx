import React, { useEffect, useState } from 'react';
import Cargando from '../../publico/components/cargando';
import Notificacion from '../components/notificacion';
import peticion from '../utils/peticion';

const Notificaciones = (props) => {

    const [notificaciones, setNotificaciones] = useState([]);
    const [cargando, setCargando] = useState(true);

    useEffect(() => {
        peticion('notificaciones')
        .then(res => {
            setNotificaciones(res)
        })
        .catch(res => {
            alert("Ocurrió un error en el servidor")
        })
        .then(() => {
            setCargando(false)
        })
    },[])

    const eliminar = (id) => {
        peticion('notificaciones/'+id)
        .then(res => {
            const ntfs = notificaciones.filter(n => n.idNotificacion !== id);
            setNotificaciones(ntfs);
            props.setNumNotif(props.numNotificaciones - 1);
        })
        .catch(res => {
            alert("No se pudo eliminar")
        })
    }

    return <div className="pt-3">
        <h2 className="h5 pl-3"><i className="fas fa-bell"></i> ({props.numNotificaciones}) Notificaciones</h2>
        <div className="mx-auto px-4 my-4" style={{maxWidth: "1200PX"}}>
            { cargando ? 
            <Cargando/> 
            : 
                <div>
                    { notificaciones.length > 0 ?
                    notificaciones.map((ntf, index) => (
                        <Notificacion
                            key={ntf.idNotificacion}
                            index={index}
                            id={ntf.idNotificacion}
                            fecha={ntf.fecha}
                            descripcion={ntf.descripcion}
                            eliminar={eliminar}
                        />
                    ))
                    :
                    <div className="text-center">
                        <span className="h5 text-muted">No tienes notificaciones</span>
                    </div>
                    }
                </div>
            }
        </div>
    </div>

}

export default Notificaciones;