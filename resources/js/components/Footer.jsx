import React from 'react'
import Logo from './Logo'

const Footer = () => {
    return (
    <footer>
        <div id="enlaces-sugeridos">
            <p className="line-title text-primary">Enlaces sugeridos</p>
        </div>
        <div className="text-center">
            <div className="d-inline-block mb-3">
                <img className="imgEnlace mx-4" src="/images/enlace2.jpg" height="60" alt="minEducacion"/>
            </div>
            <div className="d-inline-block mb-3">
                <img className="imgEnlace mx-4" src="/images/enlace3.png" height="40" alt="icfes"/>
            </div>
            <div className="d-inline-block mb-3">
                <img className="imgEnlace mx-4" src="/images/enlace1.png" height="40" alt="usco"/>
            </div>
        </div>
        <div className="bg-primary">
            <div className="container text-light">
                <div className="row justify-content-md-center align-items-center">
                    <div className="col-md-2 my-4">
                        <div className="m-auto" style={{maxWidth:"130px"}}>
                            <Logo white={true}/>
                        </div>
                    </div>
                    <nav className="col-md-auto nav align-items-center justify-content-center px-3">
                        <a className="nav-link text-light" href="#">Empresa</a>
                        <a className="nav-link text-light" href="#">Clientes</a>
                        <a className="nav-link text-light" href="#">Contacto</a>
                    </nav>
                    <div className="col-md-4 bg-white" style={{height:"1px"}}>
                    </div>
                    <nav className="col-md-auto nav align-items-center justify-content-center px-3 my-2">
                        <a className="nav-link text-light" href="#">
                            <i className="fab icon m-0 h2 fa-facebook"></i>
                        </a>
                        <a className="nav-link text-light" href="#">
                            <i className="fab icon m-0 h2 fa-twitter"></i>
                        </a>
                        <a className="nav-link text-light" href="#">
                            <i className="fab icon m-0 h2 fa-youtube"></i>
                        </a>
                        <a className="nav-link text-light" href="#">
                            <i className="fab icon m-0 h2 fa-instagram"></i>
                        </a>
                    </nav>
                </div>
            </div>
            <div className="bg-secondary text-center small text-white py-1">
                <cite>SADE © 2021</cite>
            </div>
        </div>
    </footer>
    )
}

export default Footer
