import React from 'react'
import Header from '../../components/Header'
import NavLinksHeader from './NavLinksHeader'
import OptionsMenuUser from './OptionsMenu'

const ProfesorHeader = () => {
    return (
        <Header usuario="profesor" white={false} navLinks={NavLinksHeader} menuUser={<OptionsMenuUser/>}/>
    )
}

export default ProfesorHeader
