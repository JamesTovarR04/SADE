import React from 'react';
import ReactDOM from 'react-dom';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";

// Importando componentes
import Header from './components/header';
import Contacto from './pages/contacto';
import Informacion from './pages/informacion';
import Inicio from './pages/inicio';
import Login from './pages/login';
import EstaLogeado from './components/estaLogeado';
import Footer from './components/footer';

function AppSadePublico(){

    return <Router>
      <Header/>
      <div style={{minHeight:"90vh", marginTop:"62px"}}>
        <Switch>
          <Route exact path="/">
            <Inicio/>
          </Route>
          <Route exact path="/info">
            <Informacion/>
          </Route>
          <Route exact path="/contacto">
            <Contacto/>
          </Route>
          <EstaLogeado path="/login">
            <Login/>
          </EstaLogeado>
        </Switch>
      </div>
      <Footer/>
    </Router>;

}

if (document.getElementById('appSade')) {
    ReactDOM.render(<AppSadePublico />, document.getElementById('appSade'));
}