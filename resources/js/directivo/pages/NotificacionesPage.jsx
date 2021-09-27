import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import Cargando from '../../components/Cargando'
import Notificacion from '../../components/Notificacion'
import { UserContext } from '../../context/UserState'

const NotificacionesPage = () => {

    const { notificaciones, disminuirNotificaciones } = useContext(UserContext)

    const [listNotificaciones, setListNotificaciones] = useState([])

    useEffect(() => {
        axios.get('/api/directivo/notificaciones')
        .then((res) => {
            if(res.status == 200)
                setListNotificaciones(res.data)
        })
        .catch((err) => {
        })
    }, [])

    const eliminar = (id) => {
        axios.get('/api/directivo/notificaciones/' + id)
        .then(res => {
            const ntfs = listNotificaciones.filter(n => n.idNotificacion !== id);
            setListNotificaciones(ntfs);
            disminuirNotificaciones()
            //props.setNumNotif(props.numNotificaciones - 1);
        })
        .catch(res => {
            alert("No se pudo eliminar")
        })
    }

    return (
        <div className="page-container">
            <h2 className="line-title text-primary py-3"><i className="fas fa-bell mr-2"></i> ({notificaciones}) - Notificaciones</h2>
            { listNotificaciones.length == 0 ?
                <Cargando/>
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
                </div>
            }
        </div>
    )
}

export default NotificacionesPage
