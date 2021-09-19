import React, { useContext } from 'react'
import { Redirect, Route } from 'react-router'
import { GlobalContext } from '../../context/GlobalState'

const AuthRouter = ({ children, ...rest }) => {

    const {tipoUsuario} = useContext(GlobalContext)

    return (
        <Route
        {...rest}
        render={({ location }) =>
            tipoUsuario == "publico"
            ? ( children ) : (
            <Redirect to={{
                pathname: "/",
                state: { from: location }
            }}/>
            )
        }
        />
    )
}

export default AuthRouter
