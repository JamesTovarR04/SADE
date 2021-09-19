import React, { useEffect, useState } from 'react'

const Informacion = () => {

    const [numUsuarios,setNumUsuarios] = useState({
        estudiantes: 0,
        egresados: 0,
        docentes: 0,
        directivos: 0
    });

    useEffect(() => {
        axios.get('/api/publico/info/usuarios')
        .then((response) => {
            // handle success
            if (response.status == 200){
                setNumUsuarios(response.data)
            }
        })
    },[])

    const imgBackground = {
        backgroundImage: "url(/images/infocol.jpg)",
        backgroundRepeat: "no-repeat",
        backgroundSize: "cover",
        backgroundPosition: "center",
        minHeight: "120px"
    }

    return (
        <div className="page-container px-3">
            <h1 className="line-title text-primary py-4 m-0"><i className="fas fa-info-circle"></i> Información</h1>
            <div className="container-fluid card mb-4 border shadow">
                <div className="row">
                    <div className="col-md-5 imagencol px-0" style={imgBackground}></div>
                    <div className="col-md-7 py-4">
                        <div className="card-body">
                            <h2 className="card-title text-primary">Nombre Completo De La Escuela</h2>
                            <p className="card-text">Pocas escuelas son tan exitosas como la Academia Kunugigaoka. Es más conocida como una secundaria, pero también tiene una preparatoria para los alumnos con mejores calificaciones. Lo que hace a esta academia diferente es que es la única escuela que maneja un sistema de avance a costa de otros alumnos.</p>
                            <p className="card-text">Si tu deporte favorito es el básquetbol, entonces definitivamente tienes que estudiar en la Secundaria Teiko. Esta escuela de Tokio tiene un club de básquetbol de más de 100 miembros, y en una generación tuvo a la llamada “generación milagro”, cinco jugadores tan talentosos que eran prácticamente invencibles. Por supuesto, esto hace que su programa de deportes sea muy solicitado, y el entrar a estudiar ahí no sea nada fácil. Además, debido a lo competitivo de su equipo, cualquier jugador que no pueda juntar 20 puntos en un juego, debe tener entrenamiento extra.</p>
                            <p className="card-text text-center mb-1"><small className="text-muted">Usuarios Registrados</small></p>
                            <div className="row justify-content-center">
                                <div className="col-md mb-2 p-0 text-center"><i className="fas mr-2 fa-user-edit"></i> {numUsuarios.estudiantes} Estudiantes</div>
                                <div className="col-md mb-2 p-0 text-center"><i className="fas mr-2 fa-user-graduate"></i> {numUsuarios.egresados} Egresados</div>
                                <div className="col-md mb-2 p-0 text-center"><i className="fas mr-2 fa-user"></i> {numUsuarios.docentes} Profesores</div>
                                <div className="col-md mb-2 p-0 text-center"><i className="fas mr-2 fa-user-tie"></i> {numUsuarios.directivos} Directivos</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Informacion
