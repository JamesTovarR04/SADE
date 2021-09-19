import React from 'react'
import Eventos from '../components/Eventos'
import Publicaciones from '../components/Publicaciones'
import Slider from '../components/Slider'

const Inicio = () => {

    return (
        <div className="page-container">
            <Slider/>
            <div className="container-fluid mt-3">
                <div className="row">
                    <div className="col p-0 mb-3">
                        <Publicaciones/>
                    </div>
                    <div className="col-md-4">
                        <Eventos/>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Inicio
