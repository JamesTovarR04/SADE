import axios from "axios";
import { createContext, useEffect, useReducer } from "react";
import { globalReducer } from "./GlobalReducer";
import { typeUser } from "../helpers/typeUser"

const globalInitialState = {
    usuario: {},
    tipoUsuario: "publico",
    loadingUser: false,
};

export const GlobalContext = createContext();

export const GlobalProvider = ({ children }) => {

    const [state, dispatch] = useReducer(globalReducer, globalInitialState)

    useEffect(() => {

        dispatch({
            type: "LOADING_USER",
            payload: true
        });

        axios.get('/api/auth/user')
            .then((response) => {
                // handle success
                if (response.status == 200) {
                    dispatch({
                        type: "LOAD_USER",
                        payload: {
                            usuario: response.data,
                            tipo: typeUser(response.data.tipo)
                        }
                    });
                }

            })
            .catch((error) => {
                // handle error
            })
            .then(() => {
                dispatch({
                    type: "LOADING_USER",
                    payload: false
                })
            })

    }, [])

    const logout = async () => {

        dispatch({
            type: "LOADING_USER",
            payload: true
        });

        await axios.get('/api/auth/logout')
            .then((response) => {
                // handle success
                if (response.status == 200) {
                    dispatch({
                        type: "LOGOUT_USER",
                    });
                }

            })
            .catch((error) => {
                // handle error
            })
            .then(() => {
                dispatch({
                    type: "LOADING_USER",
                    payload: false
                })
            })
    }

    return <GlobalContext.Provider value={{ ...state, logout }}>
        {children}
    </GlobalContext.Provider>

}
