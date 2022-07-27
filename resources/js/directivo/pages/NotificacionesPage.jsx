import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import Cargando from '../../components/Cargando'
import Notificacion from '../../components/Notificacion'
import { UserContext } from '../../context/UserState'

const NotificacionesPage = () => {

    const { notificaciones, disminuirNotificaciones } = useContext(UserContext)

    const [listNotificaciones, setListNotificaciones] = useState([])

    const [cargando, setCargando] = useState(false);

    useEffect(() => {
        setCargando(true)
        axios.get('/api/directivo/notificaciones')
            .then((res) => {
                if (res.status == 200)
                    setListNotificaciones(res.data)
            })
            .catch((err) => {
            }).finally(() => {
                setCargando(false)
            })
    }, [])

    const eliminar = (id) => {
        axios.get('/api/directivo/notificaciones/' + id)
            .then(res => {
                const ntfs = listNotificaciones.filter(n => n.idNotificacion !== id);
                setListNotificaciones(ntfs);
                disminuirNotificaciones()
            })
            .catch(res => {
                alert("No se pudo eliminar")
            }).finally(() => {
                setCargando(false)
            })
    }

    return (
        <div className="page-container">
            <h2 className="line-title text-primary py-3"><i className="fas fa-bell mr-2"></i> ({notificaciones}) - Notificaciones</h2>
            {cargando ?
                <Cargando />
                :
                <div className="mx-auto px-4 mb-4">
                    {listNotificaciones.map(notificacion => {
                        return <Notificacion
                            key={notificacion.idNotificacion}
                            idNotificacion={notificacion.idNotificacion}
                            texto={notificacion.descripcion}
                            date={notificacion.fecha}
                            eliminar={eliminar}
                        />
                    })}
                    {listNotificaciones.length == 0 && <div className='text-center'>No hay notificaciones</div>}
                </div>
            }
        </div>
    )
}

export default NotificacionesPage
