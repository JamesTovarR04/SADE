import React from 'react';
import ReactDOM from 'react-dom';
import { GlobalProvider } from '../context/GlobalState';
import { UserProvider } from '../context/UserState';
import Routes from './routes/Routes';

function AppDirectivo() {

    return (
        <GlobalProvider>
            <UserProvider>
                <Routes/>
            </UserProvider>
        </GlobalProvider>
    );

}

export default AppDirectivo;

if (document.getElementById('appDirectivo')) {
    ReactDOM.render(<AppDirectivo />, document.getElementById('appDirectivo'));
}