import React from 'react'
import { Route } from 'react-router'

import MenuAdministrar from '../components/menuAdministrar'
import Directivos from './subpages/directivos'
import Estudiantes from './subpages/estudiantes'
import Grados from './subpages/grados'
import Profesores from './subpages/profesores'

const AdministrarPage = () => {
    return <div className="container-fluid">
        <div className="row">
            <div className="col-3 p-0 bg-light border-right">
                <MenuAdministrar/>
            </div>
            <div className="col-9 p-3">
                <Route path="/directivo/administrar/estudiantes">
                    <Estudiantes />
                </Route>
                <Route path="/directivo/administrar/profesores">
                    <Profesores />
                </Route>
                <Route path="/directivo/administrar/directivos">
                    <Directivos />
                </Route>
                <Route path="/directivo/administrar/grados/:nivel?">
                    <Grados />
                </Route>
            </div>
        </div>
    </div>
}

export default AdministrarPage
