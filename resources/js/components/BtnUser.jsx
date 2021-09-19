import React, { useContext } from 'react'
import propTypes from 'prop-types'

import { GlobalContext } from '../context/GlobalState'

const BtnUser = ({ 
    white = false,
    click = () => { }
}) => {

    const {loadingUser, tipoUsuario, usuario} = useContext(GlobalContext);

    const bgColor = "btn-" + tipoUsuario
    const txtColor = white ? "text-" + tipoUsuario : ""
    const border = white ? "border-" + tipoUsuario : ""

    return (
        <button 
        className={`btn ${bgColor} btn-user ${txtColor} ${border} ${white && 'bg-white'} d-flex align-items-center p-0 rounded-pill text-capitalize`}
        onClick={() => click()}
        disabled={loadingUser}
        >
            <div className="m-1">
                <i className="fas fa-user-circle"></i>
            </div>
            { tipoUsuario == "publico" ?
            <div className="mr-3 ml-1">
                <span>{loadingUser ? "Cargando..." : "Iniciar Sesión"}</span>
            </div>
            :
            <div className="mr-3 ml-1">
                <div className={`small ${white && `text-${tipoUsuario}-2`}`}>
                    <span>{usuario.nombres}</span>
                </div>
                <div className="micro">
                    <span>{tipoUsuario}</span>
                </div>
            </div>
            }
        </button>
    )

}

BtnUser.propTypes = {
    white: propTypes.bool,
    click: propTypes.func
}

export default React.memo(BtnUser)