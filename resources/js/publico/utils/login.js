import axios from 'axios';
import { URL_SERVER } from '../config';

export function isLogin(){
	if(localStorage["session"] === undefined)
		return false;
	else
		return JSON.parse(localStorage["session"]).isLoggedIn;
}

export function saveDataUser(){

	const options = {
		method: 'GET',
		url: URL_SERVER + '/api/auth/user',
		headers: {
			'Accept' : 'application/json',
        	'Content-Type' : 'application/json',
			'Authorization' : JSON.parse(localStorage["session"]).user.access_token
		}
	};

	return axios(options)
	.then(res => {
		localStorage["user-data"] = JSON.stringify(res.data);
	})
	.catch(err => {
		alert('Ocurrió un error al cargar los datos de la sesion')
	})

}

export function logout(){

    const options = {
		method: 'GET',
		url: URL_SERVER + '/api/auth/logout',
		headers: {
			'Accept' : 'application/json',
			'Authorization' : JSON.parse(localStorage["session"]).user.access_token
		}
	};

	return axios(options)
	.then(res => {
		localStorage.removeItem('session');
		localStorage.removeItem('user-data');
	})
	.catch(err => {
		alert('Ocurrió un error al cerrar la sesion :(');
	})

}