export const userReducer = (state, action) => {
    
    switch (action.type) {
        case "LOAD_NOTIFICATIONS":
            return {
                ...state,
                notificaciones: action.payload.notificaciones,
            };
        case "SUBTRACT_NOTIFICATIONS":
            return {
                ...state,
                notificaciones: state.notificaciones - 1,
            };
        default:
            return state;
    }

}