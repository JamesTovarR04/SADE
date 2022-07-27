import React from 'react'

import Paginacion from "../../components/Paginacion"
import Cargando from '../../components/Cargando'
import Publicacion from '../../components/Publicacion'
import fecha from '../../helpers/fecha'
import usePublicaciones from '../../hooks/usePublicaciones'

const Publicaciones = () => {

    const [publicaciones, cargando, error, setPage] = usePublicaciones('publico')

    return <>
        <h2 className="line-title text-primary"><i className="fas fa-newspaper mr-1"></i> Publicaciones</h2>
        <div className="mt-3">
            {cargando ? <Cargando error={error} />
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
                            />
                        ))}
                        {publicaciones.data.length == 0 && <div className='text-center'>No hay publicaciones</div>}
                    </div>
                    <Paginacion pagina={setPage} last={publicaciones.last_page} current={publicaciones.current_page} />
                </div>}
        </div>
    </>
}

export default Publicaciones
