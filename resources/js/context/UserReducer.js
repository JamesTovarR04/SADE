export const userReducer = (state, action) => {
    
    switch (action.type) {
        case "LOAD_NOTIFICATIONS":
            return {
                ...state,
                notificaciones: action.payload.notificaciones,
            };
        default:
            return state;
    }

}