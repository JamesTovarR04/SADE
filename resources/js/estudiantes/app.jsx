import React from 'react';
import ReactDOM from 'react-dom';
import { isLogin } from '../publico/utils/login';
import Rutas from './rutas';

const AppSadeEstudiante = () => {

    // Si no esta logeado redirecciona a login
	if(!isLogin()){
		window.location.assign('/login');
	}else{
		// Si intenta acceder a otro usuario
		if(JSON.parse(localStorage["session"]).user.rol != 'estudiante'){
			window.location.assign('/'+JSON.parse(localStorage["session"]).user.rol);
		}else{
			return (<Rutas/>);
		}
	}

}

if (document.getElementById('appSade')) {
    ReactDOM.render(<AppSadeEstudiante />, document.getElementById('appSade'));
}