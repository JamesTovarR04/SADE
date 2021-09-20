import React, { useContext, useEffect, useState } from 'react'
import propTypes from 'prop-types'

import BtnUser from './BtnUser'
import Logo from './Logo'
import { GlobalContext } from '../context/GlobalState'
import { useHistory } from 'react-router'

const Header = ({
    usuario = "publico",
    white = true,
    navLinks,
    menuUser
}) => {

    const { tipoUsuario } = useContext(GlobalContext)
    let history = useHistory()

    const [showMenu, setShowMenu] = useState(false)

    let styleColors = ""

    if(white)
        styleColors = `navbar-light bg-white border-bottom border-${usuario}`
    else
        styleColors = `navbar-dark bg-${usuario}`

    const clickBtnUser = () => {
        if (tipoUsuario == "publico") {
            history.push("/login")
        } else {
            setShowMenu(!showMenu)
        }
    }

    const cerrarMenu = (e) => {
        setShowMenu(false)
        document.removeEventListener(e.type, cerrarMenu)
    }
    
    useEffect(() => {
        if(showMenu)
            document.addEventListener("click", cerrarMenu)
        
        return () => {
            document.removeEventListener("click", cerrarMenu)
        }
    }, [showMenu])

    return <nav className={`navbar navbar-expand-lg shadow fixed-top ${styleColors}`}>
        <a className="navbar-brand ml-4" href="/">
            <Logo height="35px" white={!white}/>
        </a>
        <div className="collapse navbar-collapse justify-content-end" id="navbarNav">
            { navLinks }
        </div>
        <div className="dropdown mr-4">
            <BtnUser white={!white} click={clickBtnUser}/>
            { tipoUsuario != "publico" && 
                <div className={"dropdown-menu dropdown-menu-right mt-3" + (showMenu ? " show" : "")} >
                    { menuUser }
                </div>
            }
        </div>
    </nav>;
}

Header.propTypes = {
    white: propTypes.bool,
    textBtnUser: propTypes.string,
    usuario: propTypes.oneOf(['publico','directivo','profesor','estudiante']),
    navLinks: propTypes.element,
    menuUser: propTypes.element
}

export default Header
