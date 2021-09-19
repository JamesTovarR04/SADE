import React from 'react'
import Header from '../../components/Header'
import NavLinksHeader from './NavLinksHeader'
import OptionsMenuUser from './OptionsMenuUser'

const PublicHeader = () => {
    return (
        <Header navLinks={NavLinksHeader} menuUser={<OptionsMenuUser/>}/>
    )
}

export default PublicHeader
