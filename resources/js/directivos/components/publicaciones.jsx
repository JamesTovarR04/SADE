import React, { useEffect, useState } from 'react';
import Cargando from '../../publico/components/cargando';
import Paginacion from '../../publico/components/paginacion';
import fecha from '../../publico/utils/fecha';
import peticion from '../utils/peticion';
import Publicacion from './publicacion';
import Publicar from './publicar';

const Publicaciones = () => {

    const [publicaciones,setPublicaciones] = useState([])
    const [cargando,setCargando] = useState(true)
    const [page, setPage] = useState(1)

    useEffect(() => {
        cargarDatos()
    },[page])

    function cargarDatos(){
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
    }

    function pagina(page){
        setPage(page)
    }

    return <div className="my-3">
        <h2 className="h5 pl-3"><i className="fas fa-newspaper mr-1"></i> Publicaciones</h2>
        <div className="mt-3">
            <Publicar recargar={cargarDatos}/>
            {cargando ? <Cargando/>
            : <div>
                <div className="mb-3">
                {publicaciones.data.map(publicacion => (
                    <Publicacion 
                        key={publicacion.idPublicacion}
                        id={publicacion.idPublicacion}
                        titulo={publicacion.titulo}
                        contenido={publicacion.contenido}
                        idUsuario={publicacion.idUsuario}
                        usuario={publicacion.nombreCompleto}
                        tipo={publicacion.tipo}
                        likes={publicacion.nlikes}
                        dislikes={publicacion.ndislikes}
                        conlike={publicacion.conlike}
                        condislike={publicacion.condislike}
                        fecha={fecha(publicacion.fecha, true)}
                        recargar={cargarDatos}
                    />
                ))}
                </div>
                <Paginacion pagina={pagina} last={publicaciones.last_page} current={publicaciones.current_page} />
            </div>}
        </div>
    </div>
    
}

export default Publicaciones;