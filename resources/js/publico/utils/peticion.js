import axios from 'axios';
import { URL_SERVER } from '../config';

export default function peticion(url, method='GET', data = {}) {

    var headers = {
        'Accept' : 'application/json',
        'Content-Type' : 'application/json',
    }

    let peticion = {
        method: method,
        url: URL_SERVER + '/api/publico/' + url,
        headers: headers,
        params: data
    };
    return axios.request(peticion).then(result => result.data)

}