import React from 'react';
import { Route } from 'react-router-dom';
import ListaDirectivos from './components/listaDirectivos';
import RegistrarDirectivo from './components/registrarDirectivo';
import VerDirectivo from './components/verDirectivo';

const Directivos = () => {

    return <div className="card">
        <div className="card-header text-center pb-0">
            <h2 className="card-title text-primary"><i className="fas fa-user-tie mr-2 ml-3"></i> Directivos</h2>
        </div>
        <div className="card-body">
            <Route exact path="/directivo/administrar/directivos">
                <ListaDirectivos />
            </Route>
            <Route exact path="/directivo/administrar/directivos/ver/:id/:option?">
                <VerDirectivo />
            </Route>
            <Route path="/directivo/administrar/directivos/registrar">
                <RegistrarDirectivo />
            </Route>
        </div>
    </div>

}

export default Directivos;