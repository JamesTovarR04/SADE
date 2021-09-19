import React from 'react'
import { NavLink } from 'react-router-dom'

const NavLinksHeader = <ul className="navbar-nav mr-3">
    <li className="nav-item">
        <NavLink exact to="/" className='nav-link mx-2'>Inicio</NavLink>
    </li>
    <li className="nav-item">
        <NavLink to="/informacion" className='nav-link mx-2'>Información</NavLink>
    </li>
    <li className="nav-item">
        <NavLink to="/contacto" className='nav-link mx-2'>Contacto</NavLink>
    </li>
</ul>
    

export default NavLinksHeader
