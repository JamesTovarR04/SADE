import React from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
} from "react-router-dom";
import Footer from '../publico/components/footer';
import Header from './components/header';

const Rutas = () => {

    return <Router>
        <Header/>
        <div style={{minHeight:"90vh", marginTop:"62px"}}>
            <Switch>
                <Route exact path="/profesor/">
                    <h1>Inicio</h1>
                </Route>
                <Route exact path="/profesor/notificaciones">
                    <h1>Notificaciones</h1>
                </Route>
                <Route exact path="/profesor/planillas">
                    <h1>Planillas</h1>
                </Route>
                <Route exact path="/profesor/perfil">
                    <h1>Perfil</h1>
                </Route>
            </Switch>
        </div>
        <Footer/>
    </Router>

}

export default Rutas;