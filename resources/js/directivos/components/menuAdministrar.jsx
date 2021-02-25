import React from 'react';
import { NavLink } from 'react-router-dom';

const MenuAdministrar = () => {

    return <div className="pt-3">
        <h2 className="h5"><i className="fas fa-folder-open mr-2"></i> Administrar</h2>
        <div className="list-group list-group-flush mt-3">
            <div className="list-group-item border-top border-bottom pl-5">
                <i className="fas fa-users mr-1"></i> <span>Usuarios</span>
            </div>
                <NavLink to="/directivo/administrar/estudiantes" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-user-graduate mr-2 ml-3"></i>
                    <span>Estudiantes</span>
                </NavLink>
                <NavLink to="/directivo/administrar/profesores" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-chalkboard-teacher mr-2 ml-3"></i>
                    <span>Profesores</span>
                </NavLink>
                <NavLink to="/directivo/administrar/directivos" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-user-tie mr-2 ml-3"></i>
                    <span>Directivos</span>
                </NavLink>
            <NavLink to="/directivo/administrar/grados" activeClassName="text-primary" className="list-group-item text-body text-decoration-none border-top border-bottom pl-5">
                <i className="fas fa-cubes mr-1"></i> <span>Grados</span>
            </NavLink>
                <NavLink to="/directivo/administrar/grados/primaria" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-cube mr-2 ml-3"></i>
                    <span>Primaria</span>
                </NavLink>
                <NavLink to="/directivo/administrar/grados/secundaria" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-cube mr-2 ml-3"></i>
                    <span>Secundaria</span>
                </NavLink>
                <NavLink to="/directivo/administrar/grados/media" activeClassName="text-primary" className="list-group-item list-group-item-action border-0 pl-5">
                    <i className="fas fa-cube mr-2 ml-3"></i>
                    <span>Educación Media</span>
                </NavLink>
        </div>
    </div>

}

export default MenuAdministrar;