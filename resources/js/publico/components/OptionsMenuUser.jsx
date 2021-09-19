import React, { useContext, useEffect } from 'react'
import { GlobalContext } from '../../context/GlobalState'

const OptionsMenuUser = () => {

    const { logout, tipoUsuario } = useContext(GlobalContext)

    const redirectPlatform = () => {
        window.location.assign('/'+ tipoUsuario );
    }

    return (
    <>
        <button className="dropdown-item" type="button" onClick={redirectPlatform}>
            <i className="fas fa-dice-d6 mr-3 text-secondary"></i>
            Plataforma
        </button>
        <button className="dropdown-item" type="button" onClick={logout}>
            <i className="fas fa-sign-out-alt mr-3 text-secondary"></i>
            Cerrar Sesión
        </button>
    </>
    )
}

export default OptionsMenuUser
