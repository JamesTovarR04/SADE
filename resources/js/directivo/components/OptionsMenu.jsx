import React, { useContext } from 'react'
import { GlobalContext } from '../../context/GlobalState'

const OptionsMenuUser = () => {

    const { logout } = useContext(GlobalContext)

    const logoutAndExit = () => {
        logout()
        window.location.assign('/login')
    }
 
    return (
    <>
        <button className="dropdown-item" type="button">
            <i className="fas fa-cogs mr-3 text-secondary"></i>
            Perfil
        </button>
        <button className="dropdown-item" type="button" onClick={logoutAndExit}>
            <i className="fas fa-sign-out-alt mr-3 text-secondary"></i>
            Cerrar Sesión
        </button>
    </>
    )
}

export default OptionsMenuUser
