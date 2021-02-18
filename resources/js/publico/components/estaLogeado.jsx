import React from 'react';
import { Redirect, Route } from 'react-router-dom';
import { isLogin } from '../utils/login';

const EstaLogeado = ({children, ...rest}) =>{

    return <Route
        {...rest}
        render={({ location }) =>
        isLogin() ? (
            <Redirect
            to={{
                pathname: "/",
                state: { from: location }
            }}
            />
        ) : ( children )
        }
    />

}

export default EstaLogeado;