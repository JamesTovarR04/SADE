export const typeUser = (numTypeUser) => {

    switch (numTypeUser) {
        case 1: return "estudiante";
        case 2: return "profesor";
        case 3: return "directivo";
        default: return "publico";
    }
    
}
