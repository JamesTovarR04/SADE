import React from 'react';
import { NavLink } from "react-router-dom";

import '../styles/header.css';
import BotonLogin from './botonLogin';

const Header = () => {

    return <nav className="navbar navbar-expand-lg navbar-light bg-light shadow fixed-top">
        <a className="navbar-brand ml-4" href="/">
            <img src="/images/logo-azul.svg" height="35" className="d-inline-block align-top" alt="SADE"/>
        </a>
        <div className="collapse navbar-collapse justify-content-end mr-4" id="navbarNav">
            <ul className="navbar-nav mr-3">
                <li className="nav-item">
                    <NavLink exact to="/" className='nav-link mx-2'>Inicio</NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/info" className='nav-link mx-2'>Información</NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/contacto" className='nav-link mx-2'>Contacto</NavLink>
                </li>
            </ul>
            <BotonLogin/>
        </div>
    </nav>;

}

export default Header;