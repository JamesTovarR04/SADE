import React from 'react'
import { NavLink } from 'react-router-dom'
import IconoNotificaciones from '../../components/IconoNotificaciones'

const NavLinksHeader = <ul className="navbar-nav mr-3">
    <li className="nav-item">
        <NavLink exact to="/estudiante" className='nav-link mx-2'><i className="fas fa-newspaper mr-2"></i> Publicar</NavLink>
    </li>
    <li className="nav-item">
        <NavLink to="/estudiante/migrupo" className='nav-link mx-2'><i class="fas fa-users mr-2"></i>Mi Grupo</NavLink>
    </li>
    <li className="nav-item border-left border-white">
        <NavLink to="/estudiante/notificaciones" className='nav-link mx-2'>
            <IconoNotificaciones/>
        </NavLink>
    </li>
</ul>

export default NavLinksHeader