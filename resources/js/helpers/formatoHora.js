// Pasa la hora de formaato 24 a 12

export default function formatoHora (hora){
    var fecha = new Date(hora);
    var horaF = '';

    if(fecha.getHours() > 12 || fecha.getHours() == 0){
        horaF = Math.abs(fecha.getHours()-12) + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + ((fecha.getHours() == 0)? ' a.m.' : ' p.m');
    }else{
        horaF = fecha.getHours() + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + " a.m.";
    }

    return horaF;
}