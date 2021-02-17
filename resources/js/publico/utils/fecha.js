export const meses = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"];

export const dias = [
    "Domindo","Lunes", "Martes", "Miércoles", "Jueves", "Viernes","Sábado"
];

export default function fecha(string = null,verHora = false,formato=1){
    var fecha = new Date(string);
    var hora = '';
    if(fecha.getHours() > 12 || fecha.getHours() == 0){
        hora = Math.abs(fecha.getHours()-12) + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + ((fecha.getHours() == 0)? ' a.m.' : ' p.m');
    }else{
        hora = fecha.getHours() + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + " a.m.";
    }
    hora = (verHora)? hora + ' ' : '';

    switch(formato){
        case 1:
            let salida = hora + fecha.getDate() + ' de ' + meses[fecha.getMonth()] + ', ' + fecha.getFullYear();
            return salida;
    }
}