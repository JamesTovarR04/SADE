import React from 'react'

const Contacto = () => {
    return (
        <div className="page-container px-3">
            <h1 className="line-title text-primary py-4 m-0"><i className="fas fa-phone-alt mr-2"></i> Contacto</h1>
            <div className="container-fluid card mb-4 border shadow">
                <div className="row">
                    <div className="col-md d-flex justify-content-center aling-items-center">
                        <div className="d-flex justify-content-center flex-column py-5">
                            <div className="row mb-4 justify-content-center">
                                <div className="px-4">
                                    <h6 className="text-primary text-center">TELEFONOS</h6>
                                    <ul className="list-unstyled">
                                        <li>(+57) 317 4456871 - Telefono</li>
                                        <li>(+57) 310 8773870 - Telefono</li>
                                        <li>(+57) 322 4280444 - Telefono</li>
                                    </ul>
                                </div>
                                <div className="px-4">
                                    <h6 className="text-primary text-center">CORREOS</h6>
                                    <ul className="list-unstyled">
                                        <li>sade@edu.com.co - correo</li>
                                        <li>sade@gmail.com - correo</li>
                                        <li>sade@usco.edu.co - correo</li>
                                    </ul>
                                </div>                 
                            </div>
                            <h6 className="text-center text-primary">REDES SOCIALES</h6> 
                            <div className="icons text-center">
                                <i className="fab fa-facebook mx-3"></i>
                                <i className="fab fa-twitter mx-3"></i>
                                <i className="fab fa-youtube mx-3"></i>
                                <i className="fab fa-instagram mx-3"></i>
                            </div>
                        </div>
                    </div>
                    <div className="col-md p-0">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m10!1m8!1m3!1d4992.010427185254!2d-75.25930142778772!3d2.9415166104178914!3m2!1i1024!2i768!4f13.1!5e0!3m2!1ses!2sco!4v1613627142795!5m2!1ses!2sco" width="100%" height="450" frameBorder="0" allowFullScreen="" aria-hidden="false" tabIndex="0"></iframe>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Contacto
