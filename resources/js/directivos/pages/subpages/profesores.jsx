import React from 'react';
import { Route } from 'react-router-dom';
import ListaProfesores from './components/listaProfesores';
import RegistrarProfesor from './components/registrarProfesor';
import VerProfesor from './components/verProfesor';

const Profesores = () => {

    return <div className="card">
        <div className="card-header text-center pb-0">
            <h5 className="card-title"><i className="fas fa-chalkboard-teacher mr-2 ml-3"></i> Profesores</h5>
        </div>
        <div className="card-body">
            <Route exact path="/directivo/administrar/profesores">
                <ListaProfesores />
            </Route>
            <Route exact path="/directivo/administrar/profesores/ver/:id/:option?">
                <VerProfesor />
            </Route>
            <Route path="/directivo/administrar/profesores/registrar">
                <RegistrarProfesor />
            </Route>
        </div>
    </div>

}

export default Profesores;