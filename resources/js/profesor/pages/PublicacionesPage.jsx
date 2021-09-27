import React from 'react'
import Eventos from '../components/Eventos'
import Publicaciones from '../components/Publicaciones'

const PublicacionesPage = () => {
    return (
        <div className="container-fluid pt-3">
            <div className="row">
                <div className="col p-0 mb-3">
                    <Publicaciones/>
                </div>
                <div className="col-md-4">
                    <Eventos/>
                </div>
            </div>
        </div>
    )
}

export default PublicacionesPage
