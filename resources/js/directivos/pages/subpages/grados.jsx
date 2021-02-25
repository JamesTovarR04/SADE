import React from 'react';
import { Route } from 'react-router-dom';
import ListaGrados from './components/listaGrados';
import RegistrarGrado from './components/registrarGrado';

const Grados = () => {

    return <div className="card">
        <div className="card-header text-center pb-0">
            <h5 className="card-title"><i className="fas fa-cubes mr-1"></i> Grados</h5>
        </div>
        <div className="card-body">
            <Route exact path="/directivo/administrar/grados">
                <ListaGrados />
            </Route>
            <Route exact path="/directivo/administrar/grados/registrar">
                <RegistrarGrado />
            </Route>
        </div>
    </div>

}

export default Grados;