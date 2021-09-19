export const globalReducer = (state, action) => {
    
    switch (action.type) {
        case "LOAD_USER":
            return {
                ...state,
                usuario: action.payload.usuario,
                tipoUsuario: action.payload.tipo
            };
        case "LOADING_USER":
            return {
                ...state,
                loadingUser: action.payload
            }
        case "LOGOUT_USER":
            return {
                ...state,
                usuario: {},
                tipoUsuario: "publico"
            };
        default:
            return state;
    }

}