import React from 'react';
import ReactDOM from 'react-dom';
import { GlobalProvider } from '../context/GlobalState';
import { UserProvider } from '../context/UserState';
import Routes from './routes/Routes';

function AppEstudiantes() {

    return (
        <GlobalProvider>
            <UserProvider>
                <Routes/>
            </UserProvider>
        </GlobalProvider>
    );
}
export default AppEstudiantes;

if (document.getElementById('appEstudiante')) {
    ReactDOM.render(<AppEstudiantes />, document.getElementById('appEstudiante'));
}