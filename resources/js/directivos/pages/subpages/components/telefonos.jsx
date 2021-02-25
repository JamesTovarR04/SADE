import React, { useState } from 'react';

const Telefonos = (props) => {

    const [telefonos,setTelefonos] = useState(props.telefonos);

    const getColor = () => {
        let colors = ['bg-info','bg-success','bg-primary'];
        return colors[Math.floor(Math.random()*(colors.length))];
    }

    return <div>
        { telefonos.map(telefono => (
            <div 
                key={telefono.idTelefono}
                className={getColor() + " card mx-1 d-inline-block text-white px-2 py-1"}
            >
                {telefono.telefono}
            </div>
        ))}
    </div>

}

export default Telefonos;