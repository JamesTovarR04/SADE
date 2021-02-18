import React, { useEffect, useState } from 'react';

const Evento = (props) => {

    const [color,setColor] = useState('bg-secondary');
    const [hora,setHora] = useState('00:00 --');

    useEffect(() => {
        let colors = ['bg-info','bg-success','bg-primary'];
        setColor(colors[Math.floor(Math.random()*(colors.length))]);
        var fecha = new Date(props.hora);
        var horaF = '';
        if(fecha.getHours() > 12 || fecha.getHours() == 0){
            horaF = Math.abs(fecha.getHours()-12) + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + ((fecha.getHours() == 0)? ' a.m.' : ' p.m');
        }else{
            horaF = fecha.getHours() + ":" + ((fecha.getMinutes() < 10) ? '0' : '') + fecha.getMinutes() + " a.m.";
        }
        setHora(horaF)
    },[]);
    

    return <div className={color + " card mt-2 p-3 text-white"} style={{borderRadius: "20px"}}>
        <strong className="d-block text-center">{hora}</strong>
        <span>{props.descripcion}</span>
    </div>

}

export default Evento;