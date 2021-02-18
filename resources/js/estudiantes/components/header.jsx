import React from 'react';
import { NavLink } from "react-router-dom";
import BotonLogin from '../../directivos/components/botonLogin';

import '../styles/header.css';


const Header = () => {

    return <nav className="navbar navbar-expand-lg navbar-dark shadow fixed-top">
        <a className="navbar-brand ml-4" href="/">
            <img src="/images/logo-blanco.svg" height="35" className="d-inline-block align-top" alt="SADE"/>
        </a>
        <div className="collapse navbar-collapse justify-content-end mr-4" id="navbarNav">
            <ul className="navbar-nav mr-3">
                <li className="nav-item">
                    <NavLink exact to="/estudiante/" className='nav-link mx-2 py-0'>
                        <i className="fas fa-newspaper"></i>
                    </NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/estudiante/migrupo" className='nav-link mx-2 py-0'>
                        <i className="fas fa-users"></i>
                    </NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/estudiante/notificaciones" className='nav-link mx-2 py-0'>
                        <i className="fas fa-bell"></i>
                    </NavLink>
                </li>
            </ul>
            <BotonLogin/>
        </div>
    </nav>;

}

export default Header;