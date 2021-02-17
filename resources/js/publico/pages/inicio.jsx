import React from 'react';
import Eventos from '../components/eventos';

import Publicaciones from '../components/publicaciones';
import Slider from '../components/slider';

const Inicio = () => {

    return <div>
        <Slider/>
        <div className="container-fluid">
            <div className="row">
                <div className="col-9 p-0"><Publicaciones/></div>
                <div className="col-3"><Eventos/></div>
            </div>
        </div>
    </div>;

}

export default Inicio;