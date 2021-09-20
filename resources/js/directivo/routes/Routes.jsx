import React from 'react'
import { 
    BrowserRouter as Router, 
    Route, 
    Switch 
} from 'react-router-dom'

import Footer from '../../components/Footer'
import DirectivoHeader from '../components/DirectivoHeader'

import PublicacionsPage from '../pages/PublicacionesPage'

const Routes = () => {
    return (
        <Router>
            <DirectivoHeader/>
            <div className="page-container">
                <Switch>
                    <Route exact path="/directivo"><PublicacionsPage/></Route>
                </Switch>
            </div>
            <Footer/>
        </Router>
    )
}

export default Routes
