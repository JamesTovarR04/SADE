import React from 'react'
import { 
    BrowserRouter as Router, 
    Route, 
    Switch 
} from 'react-router-dom'

import Footer from '../../components/Footer'
import EstudianteHeader from '../components/EstudianteHeader'

import PublicacionesPage from '../pages/PublicacionesPage'
import MiGrupoPage from '../pages/MiGrupoPage'

const Routes = () => {
    return (
        <Router>
            <EstudianteHeader/>
            <div className="page-container">
                <Switch>
                    <Route exact path="/estudiante"><PublicacionesPage/></Route>
                    <Route exact path="/estudiante/migrupo"><MiGrupoPage/></Route>
                </Switch>
            </div>
            <Footer/>
        </Router>
    )
}

export default Routes
