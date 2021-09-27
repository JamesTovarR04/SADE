import React from 'react'
import { 
    BrowserRouter as Router, 
    Route, 
    Switch 
} from 'react-router-dom'

import Footer from '../../components/Footer'
import DirectivoHeader from '../components/DirectivoHeader'

import AdministrarPage from '../pages/AdministrarPage'
import NotificacionesPage from '../pages/NotificacionesPage'
import PublicacionsPage from '../pages/PublicacionesPage'

const Routes = () => {
    return (
        <Router>
            <DirectivoHeader/>
            <div className="page-container">
                <Switch>
                    <Route exact path="/directivo"><PublicacionsPage/></Route>
                    <Route path="/directivo/administrar"><AdministrarPage/></Route>
                    <Route exact path="/directivo/notificaciones"><NotificacionesPage/></Route>
                </Switch>
            </div>
            <Footer/>
        </Router>
    )
}

export default Routes
