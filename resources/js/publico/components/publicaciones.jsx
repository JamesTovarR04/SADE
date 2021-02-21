import React, { useEffect, useState } from 'react';
import fecha from '../utils/fecha';
import peticion from '../utils/peticion';
import Cargando from './cargando';
import Paginacion from './paginacion';
import Publicacion from './publicacion';

const Publicaciones = () => {

    const [publicaciones,setPublicaciones] = useState([])
    const [cargando,setCargando] = useState(true)
    const [page, setPage] = useState(1)

    useEffect(() => {
        peticion('publicaciones','GET',{'page':page})
        .then(data => {
            setPublicaciones(data)
        })
        .catch(err => {
            alert("Ocurrió un error en el servidor")
        })
        .then(() => {
            setCargando(false)
        })
    },[page])

    function pagina(page){
        setPage(page)
    }

    return <div className="my-3">
        <h2 className="h5 pl-3"><i className="fas fa-newspaper mr-1"></i> Publicaciones</h2>
        <div className="mt-3">
            {cargando ? <Cargando/>
            : <div>
                <div className="mb-3">
                {publicaciones.data.map(publicacion => (
                    <Publicacion 
                        key={publicacion.idPublicacion}
                        titulo={publicacion.titulo}
                        contenido={publicacion.contenido}
                        usuario={publicacion.nombreCompleto}
                        tipo={publicacion.tipo}
                        likes={publicacion.nlikes}
                        dislikes={publicacion.ndislikes}
                        fecha={fecha(publicacion.fecha, true)}
                    />
                ))}
                </div>
                <Paginacion pagina={pagina} last={publicaciones.last_page} current={publicaciones.current_page} />
            </div>}
        </div>
    </div>
    
}

export default Publicaciones;