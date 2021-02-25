export default function tipoDocumento(tipo){

    switch (tipo) {
        case 'CC': return 'Cédula de ciudadanía'
        case 'CE': return 'Cédula de extranjería'
        case 'RC': return 'Registro civil'
        case 'TI': return 'Tarjeta de identidad'
        default: return tipo
    }
    
}