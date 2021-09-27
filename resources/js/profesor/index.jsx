import React from 'react';
import ReactDOM from 'react-dom';
import { GlobalProvider } from '../context/GlobalState';
import { UserProvider } from '../context/UserState';
import Routes from './routes/Routes';

function AppProfesor() {

    return (
        <GlobalProvider>
            <UserProvider>
                <Routes/>
            </UserProvider>
        </GlobalProvider>
    );
}
export default AppProfesor;

if (document.getElementById('appProfesor')) {
    ReactDOM.render(<AppProfesor />, document.getElementById('appProfesor'));
}