import React, { useEffect, useState } from 'react';

import "../styles/informacion.css";
import peticion from '../utils/peticion';

const Informacion = () => {

    const [estudiantes,setEstudiantes] = useState(0);
    const [egresados,setEgresados] = useState(0);
    const [profesores,setProfesores] = useState(0);
    const [directivos,setDirectivos] = useState(0);

    useEffect(() => {
        peticion('info/usuarios','GET')
        .then(data => {
            setEstudiantes(data.estudiantes)
            setEgresados(data.egresados)
            setProfesores(data.docentes)
            setDirectivos(data.directivos)
        })
    },[])

    return <div className="py-4">
        <h2 className="h5 pl-3 mb-4"><i className="fas fa-info-circle"></i> Informacion</h2>
        <div className="card m-3">
            <div className="row">
                <div className="col-md-5 imagencol"></div>
                <div className="col-md-7">
                    <div className="card-body">
                        <h4 className="card-title">Nombre Completo De La Escuela</h4>
                        <p className="card-text">Pocas escuelas son tan exitosas como la Academia Kunugigaoka. Es más conocida como una secundaria, pero también tiene una preparatoria para los alumnos con mejores calificaciones. Lo que hace a esta academia diferente es que es la única escuela que maneja un sistema de avance a costa de otros alumnos.</p>
                        <p className="card-text">Si tu deporte favorito es el básquetbol, entonces definitivamente tienes que estudiar en la Secundaria Teiko. Esta escuela de Tokio tiene un club de básquetbol de más de 100 miembros, y en una generación tuvo a la llamada “generación milagro”, cinco jugadores tan talentosos que eran prácticamente invencibles. Por supuesto, esto hace que su programa de deportes sea muy solicitado, y el entrar a estudiar ahí no sea nada fácil. Además, debido a lo competitivo de su equipo, cualquier jugador que no pueda juntar 20 puntos en un juego, debe tener entrenamiento extra.</p>
                        <p className="card-text"> Secundaria Teiko es un lugar aburrido. Justamente por los triunfos del equipo, la escuela tiene un fuerte espíritu escolar, y todos los alumnos están ahí listos para apoyar a sus compañeros. Después de todo, hay cierto orgullo en ser parte de una escuela con un equipo campeón, incluso si uno no es parte del mismo.</p>
                        <p className="card-text text-center mb-1"><small className="text-muted">Usuarios Registrados</small></p>
                        <div className="d-flex justify-content-center">
                            <div className="mx-3"><i className="fas fa-user-edit"></i> {estudiantes} Estudiantes</div>
                            <div className="mx-3"><i className="fas fa-user-graduate"></i> {egresados} Egresados</div>
                            <div className="mx-3"><i className="fas fa-user"></i> {profesores} Profesores</div>
                            <div className="mx-3"><i className="fas fa-user-tie"></i> {directivos} Directivos</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

}

export default Informacion;