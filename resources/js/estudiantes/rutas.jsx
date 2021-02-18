import React from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
} from "react-router-dom";
import Footer from '../publico/components/footer';
import Header from './components/header';

const Rutas = () => {

    return  <Router>
        <Header/>
        <div style={{minHeight:"90vh", marginTop:"62px"}}>
            <Switch>
                <Route exact path="/estudiante/">
                    <h1>Inicio</h1>
                </Route>
                <Route exact path="/estudiante/notificaciones">
                    <h1>Notificaciones</h1>
                </Route>
                <Route exact path="/estudiante/migrupo">
                    <h1>Mi Grupo</h1>
                </Route>
                <Route exact path="/estudiante/perfil">
                    <h1>Perfil</h1>
                </Route>
            </Switch>
        </div>
        <Footer/>
    </Router>

}

export default Rutas;