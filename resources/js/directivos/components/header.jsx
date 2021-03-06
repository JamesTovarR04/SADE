import React from 'react';
import { NavLink } from "react-router-dom";

import '../styles/header.css';
import BotonLogin from './botonLogin';

const Header = (props) => {

    return <nav className="navbar navbar-expand-lg navbar-dark shadow fixed-top">
        <a className="navbar-brand ml-4" href="/">
            <img src="/images/logo-blanco.svg" height="35" className="d-inline-block align-top" alt="SADE"/>
        </a>
        <div className="collapse navbar-collapse justify-content-end mr-4" id="navbarNav">
            <ul className="navbar-nav mr-3">
                <li className="nav-item">
                    <NavLink exact to="/directivo/" className='nav-link mx-2 py-0'>
                        <i className="fas fa-newspaper"></i>
                    </NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/directivo/administrar/estudiantes" className='nav-link mx-2 py-0'>
                        <i className="fas fa-folder-open"></i>
                    </NavLink>
                </li>
                <li className="nav-item">
                    <NavLink to="/directivo/notificaciones" className='nav-link mx-2 py-0'>
                        <div className="position-relative">
                            <i className="fas fa-bell"></i>
                            { props.notificaciones > 0 &&
                                <span id="num-notificaciones" className="bg-danger text-white rounded-circle d-block">{props.notificaciones}</span>
                            }
                        </div>
                    </NavLink>
                </li>
            </ul>
            <BotonLogin/>
        </div>
    </nav>;

}

export default Header;