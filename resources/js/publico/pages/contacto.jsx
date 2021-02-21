import React from 'react';
import "../styles/contacto.css";

const Contacto = () => {

    return <div className="py-4">
        <h2 className="h5 pl-3"><i className="fas fa-phone-alt"></i> Contacto</h2>
        <div className="container-fluid card my-4 border shadow">
            <div className="row">
                <div className="col d-flex justify-content-center aling-items-center">
                    <div className="container">
                        <div className="row">
                            <div className="col info">
                                <h6>TELEFONOS</h6>
                                <p>(+57) 317 4456871 - Telefono</p>
                                <p>(+57) 310 8773870 - Telefono</p>
                                <p>(+57) 322 4280444 - Telefono</p>
                            </div>
                            <div className="col info">
                                <h6>CORREOS</h6>
                                <p>sade@edu.com.co - correo</p>
                                <p>sade.edu@gmail.com - correo</p>
                                <p>sade@usco.edu.co - correo</p>
                            </div>                 
                        </div>
                        <h6 className="redesS">REDES SOCIALES</h6> 

                        <div className="icons">
                        <i class="fab fa-facebook mx-3"></i>
                        <i class="fab fa-twitter mx-3"></i>
                        <i class="fab fa-youtube mx-3"></i>
                        <i class="fab fa-instagram mx-3"></i>
                        </div>

                    </div>
                </div>
                <div className="col">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m10!1m8!1m3!1d4992.010427185254!2d-75.25930142778772!3d2.9415166104178914!3m2!1i1024!2i768!4f13.1!5e0!3m2!1ses!2sco!4v1613627142795!5m2!1ses!2sco" width="100%" height="450" frameBorder="0" allowfullscreen="" aria-hidden="false" tabindex="0"></iframe>
                </div>
            </div>
        </div>
    </div>

}

export default Contacto;