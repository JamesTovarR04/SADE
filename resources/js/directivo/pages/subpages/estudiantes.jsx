import React from 'react';
import { Route } from 'react-router-dom';
import ListaEstudiantes from './components/listaEstudiantes';
import RegistrarEstudiante from './components/registrarEstudiante';
import VerEstudiante from './components/verEstudiante';

const Estudiantes = () => {

    return <div className="card">
        <div className="card-header text-center pb-0">
            <h2 className="card-title text-primary"><i className="fas fa-user-graduate mr-2 ml-3"></i> Estudiantes</h2>
        </div>
        <div className="card-body">
            <Route exact path="/directivo/administrar/estudiantes">
                <ListaEstudiantes />
            </Route>
            <Route exact path="/directivo/administrar/estudiantes/ver/:id/:option?">
                <VerEstudiante />
            </Route>
            <Route path="/directivo/administrar/estudiantes/registrar">
                <RegistrarEstudiante />
            </Route>
        </div>
    </div>

}

export default Estudiantes;