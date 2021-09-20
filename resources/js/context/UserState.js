import axios from "axios";
import { createContext, useEffect, useReducer, useContext } from "react";
import { userReducer } from "./UserReducer";
import { GlobalContext } from "./GlobalState"

const userInitialState = {
    notificaciones: 0
};

export const UserContext = createContext();

export const UserProvider = ({ children }) => {

    const [state, dispatch] = useReducer(userReducer, userInitialState)
    const { tipoUsuario } = useContext(GlobalContext)

    useEffect(() => {
        if(tipoUsuario != "publico")
            loadNotifications()
    }, [tipoUsuario])

    const loadNotifications = () => {
        axios.get('/api/' + tipoUsuario + '/numero/notificaciones')
        .then((response) => {
            // handle success
            if (response.status == 200){
                dispatch({
                    type: "LOAD_NOTIFICATIONS",
                    payload: {
                        notificaciones: response.data.notificaciones
                    }
                });
            }
        })
        .catch((error) => {
            // handle error
        })
    }

    return <UserContext.Provider value={{...state}}>
        {children}
    </UserContext.Provider>

}
