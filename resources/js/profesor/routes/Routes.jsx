import React from 'react'
import { 
    BrowserRouter as Router, 
    Route, 
    Switch 
} from 'react-router-dom'

import Footer from '../../components/Footer'
import ProfesorHeader from '../components/ProfesorHeader'

import PublicacionesPage from '../pages/PublicacionesPage'

const Routes = () => {
    return (
        <Router>
            <ProfesorHeader/>
            <div className="page-container">
                <Switch>
                    <Route exact path="/profesor"><PublicacionesPage/></Route>
                </Switch>
            </div>
            <Footer/>
        </Router>
    )
}

export default Routes
