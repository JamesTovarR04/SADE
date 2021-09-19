import React, { useEffect, useState } from 'react';

import formatoHora from '../helpers/formatoHora'

const Evento = ({hora, descripcion}) => {

    const [color,setColor] = useState('bg-secondary');
    const [horaFormat,setHoraFormat] = useState('00:00 --');

    useEffect(() => {
        let colors = ['bg-info','bg-success','bg-primary'];
        setColor(colors[Math.floor(Math.random()*(colors.length))]);
        setHoraFormat(formatoHora(hora))
    },[]);
    
    return <div className={color + " card mt-2 p-3 text-white"} style={{borderRadius: "20px"}}>
        <strong className="d-block text-center">{horaFormat}</strong>
        <span>{descripcion}</span>
    </div>

}

export default Evento;