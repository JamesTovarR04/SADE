import React from 'react';

const Footer = () => {

    return <footer>
        <div id="enlaces-sugeridos">
            <p className="text-muted">Enlaces sugeridos</p>
        </div>
        <div className="d-flex flex-row justify-content-center align-items-center">
            <img className="imgEnlace mx-4" src="/images/enlace2.jpg" height="60" alt="minEducacion"/>
            <img className="imgEnlace mx-4" src="/images/enlace3.png" height="40" alt="icfes"/>
            <img className="imgEnlace mx-4" src="/images/enlace1.png" height="40" alt="usco"/>
        </div>
        <div className="d-flex flex-row justify-content-center align-items-center mt-4 py-4 px-5" id="MenuFooter">
            <img className="mr-4" src="/images/logo-blanco.svg" height="50" alt="SADE"/>
            <nav className="nav">
                <a className="nav-link text-light" href="#">Empresa</a>
                <a className="nav-link text-light" href="#">Clientes</a>
                <a className="nav-link text-light" href="#">Contacto</a>
            </nav>
            <div className="flex-grow-1 mx-3 line"></div>
            <i className="fab icon ml-4 fa-facebook"></i>
            <i className="fab icon ml-4 fa-twitter"></i>
            <i className="fab icon ml-4 fa-youtube"></i>
            <i className="fab icon ml-4 fa-instagram"></i>
        </div>
        <cite className="text-center small d-block text-light py-1">Copyright © 2021 SADE, Inc.</cite>
    </footer>;

}

export default Footer;