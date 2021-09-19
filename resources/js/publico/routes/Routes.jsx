import React from 'react'
import { 
    BrowserRouter as Router, 
    Route, 
    Switch 
} from 'react-router-dom'
import PublicHeader from '../components/PublicHeader'

import Inicio from '../pages/inicio'
import Login from '../pages/Login'
import Informacion from '../pages/Informacion'
import Contacto from '../pages/Contacto'
import AuthRouter from './AuthRouter'
import Footer from '../../components/Footer'

const Routes = () => {
    return (
        <Router>
            <PublicHeader/>
            <Switch>
                <Route exact path="/"><Inicio/></Route>
                <Route exact path="/informacion"><Informacion/></Route>
                <Route exact path="/contacto"><Contacto/></Route>
                <AuthRouter exact path="/login">
                    <Login/>
                </AuthRouter>
            </Switch>
            <Footer/>
        </Router>
    )
}

export default Routes
