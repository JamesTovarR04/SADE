import axios from 'axios';
import { URL_SERVER } from '../../publico/config';

export default function peticion(url, method='GET', data = {}) {

    var headers = {
        'Accept' : 'application/json',
        'Content-Type' : 'application/json',
        'Authorization': JSON.parse(localStorage["session"]).user.access_token
    }

    let peticion = {
        method: method,
        url: URL_SERVER + '/api/directivo/' + url,
        headers: headers,
        params: data
    };
    return axios.request(peticion).then(result => result.data)

}