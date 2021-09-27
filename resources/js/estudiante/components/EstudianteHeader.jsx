import React from 'react'
import Header from '../../components/Header'
import NavLinksHeader from './NavLinksHeader'
import OptionsMenuUser from './OptionsMenu'

const EstudianteHeader = () => {
    return (
        <Header usuario="estudiante" white={false} navLinks={NavLinksHeader} menuUser={<OptionsMenuUser/>}/>
    )
}

export default EstudianteHeader
