import React from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
  } from "react-router-dom";
import Footer from '../publico/components/footer';
import Header from './components/header';
import Inicio from './pages/inicio';

const Rutas = () => {

    return <Router>
        <Header/>
        <div style={{minHeight:"90vh", marginTop:"62px"}}>
            <Switch>
                <Route exact path="/directivo/">
                    <Inicio/>
                </Route>
                <Route exact path="/directivo/notificaciones">
                    <h1>Notificaciones</h1>
                </Route>
                <Route exact path="/directivo/administrar">
                    <h1>Administrar</h1>
                </Route>
                <Route exact path="/directivo/perfil">
                    <h1>Perfil</h1>
                </Route>
            </Switch>
        </div>
        <Footer/>
    </Router>

}

export default Rutas;