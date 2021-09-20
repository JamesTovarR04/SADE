import React, { useContext } from 'react'
import { UserContext } from '../context/UserState'

const IconoNotificaciones = () => {

    const { notificaciones } = useContext(UserContext)

    return (
        <div className="position-relative">
            <i className="fas fa-bell"></i>
            { notificaciones > 0 && <span id="num-notificaciones" className="bg-danger text-white rounded-circle d-block">
                {notificaciones}
            </span> }
        </div>
    )
}

export default IconoNotificaciones
