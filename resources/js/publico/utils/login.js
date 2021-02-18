import axios from 'axios';
import { URL_SERVER } from '../config';

export function isLogin(){
	if(localStorage["session"] === undefined)
		return false;
	else
		return JSON.parse(localStorage["session"]).isLoggedIn;
}

export function logout(){

    var logout = {
			method: 'GET',
			url: URL_SERVER + '/api/auth/logout',
		    headers: {
		    	'Accept' : 'application/json',
		    	'Authorization' : JSON.parse(localStorage["session"]).user.access_token
		    }
		};

	axios(logout)

	let appState = {
	    isLoggedIn: false,
	    user: {}
    };
    
    localStorage["session"] = JSON.stringify(appState);
	console.log("cerró sesion");

}