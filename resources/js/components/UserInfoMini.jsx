import React, { memo } from 'react'
import propTypes from 'prop-types'

const UserInfoMini = ({usuario, tipo}) => {

    const sizePhotoUser = "35px"

    return (
        <div className="container p-0 border-left-0">
            <div className="col p-0">
                <div className="d-flex">
                    <img src="/images/notUser.jpg" className={"rounded-circle border-" + tipo} style={{border:"2px solid"}} width={sizePhotoUser} height={sizePhotoUser}/>
                    <div className="container ml-2">
                        <div className="row">
                            <span className="small">{usuario}</span>
                        </div>
                        <div className="row">
                            <span className={"micro text-uppercase text-" + tipo}>{tipo}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

UserInfoMini.propTypes = {
    usuario: propTypes.string, 
    tipo: propTypes.string, 
}

export default memo(UserInfoMini)
