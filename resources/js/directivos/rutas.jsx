import React, { useEffect, useState } from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
  } from "react-router-dom";
import Footer from '../publico/components/footer';
import Header from './components/header';
import Inicio from './pages/inicio';
import Notificaciones from './pages/notificaciones';
import peticion from './utils/peticion';

const Rutas = () => {

    const [notificaciones, setNotificaciones] = useState(0);

    useEffect(() => {
        obtenerNotificaciones()
        startClock()
    },[])

    const startClock = () => {
        setInterval(obtenerNotificaciones,(1000 * 30));
    }

    const obtenerNotificaciones = () => {
        peticion('numero/notificaciones')
        .then(res => {
            setNotificaciones(res.notificaciones)
        })
        .catch(err => {
            
        })
    }

    return <Router>
        <Header notificaciones={notificaciones}/>
        <div style={{minHeight:"90vh", marginTop:"62px"}}>
            <Switch>
                <Route exact path="/directivo/">
                    <Inicio/>
                </Route>
                <Route exact path="/directivo/notificaciones">
                    <Notificaciones numNotificaciones={notificaciones} setNumNotif={setNotificaciones}/>
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