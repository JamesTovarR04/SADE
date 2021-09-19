import React from 'react';
import ReactDOM from 'react-dom';
import { GlobalProvider } from '../context/GlobalState';
import Routes from './routes/Routes';

function AppPublico() {

    return (
        <GlobalProvider>
            <Routes/>
        </GlobalProvider>
    );
}

export default AppPublico;

if (document.getElementById('app')) {
    ReactDOM.render(<AppPublico />, document.getElementById('app'));
}