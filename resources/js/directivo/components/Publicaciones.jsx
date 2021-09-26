import React from 'react'

import Cargando from '../../components/Cargando'
import NuevaPublicacion from '../../components/NuevaPublicacion'
import Paginacion from '../../components/Paginacion'
import Publicacion from '../../components/Publicacion'
import fecha from '../../helpers/fecha'
import usePublicaciones from '../../hooks/usePublicaciones'

const Publicaciones = () => {

    const [publicaciones, cargando, error, setPage, cargarPublicaciones] = usePublicaciones('directivo')

    return <>
        <h2 className="line-title text-primary"><i className="fas fa-newspaper mr-1"></i> Publicaciones</h2>
        <NuevaPublicacion recargar={cargarPublicaciones} />
        <div className="mt-3">
            {cargando ? <Cargando error={error}/>
            : <div>
                <div className="mb-3">
                {publicaciones.data.map(publicacion => (
                    <Publicacion
                        key={publicacion.idPublicacion}
                        titulo={publicacion.titulo}
                        contenido={publicacion.contenido}
                        nombreUsuario={publicacion.nombreCompleto}
                        tipo={publicacion.tipo}
                        likes={publicacion.nlikes}
                        dislikes={publicacion.ndislikes}
                        fecha={fecha(publicacion.fecha, true)}
                        idPublicacion={publicacion.idPublicacion}
                        idUsuario={publicacion.idUsuario}
                        conlike={Boolean(publicacion.conlike)}
                        condislike={Boolean(publicacion.condislike)}
                        recargar={cargarPublicaciones}
                    />
                ))}
                </div>
                <Paginacion pagina={setPage} last={publicaciones.last_page} current={publicaciones.current_page} />
            </div>}
        </div>
    </>
}

export default Publicaciones
