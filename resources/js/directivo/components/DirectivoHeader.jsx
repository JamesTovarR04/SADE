import React from 'react'
import Header from '../../components/Header'
import NavLinksHeader from './NavLinksHeader'
import OptionsMenuUser from './OptionsMenu'

const DirectivoHeader = () => {
    return (
        <Header usuario="directivo" white={false} navLinks={NavLinksHeader} menuUser={<OptionsMenuUser/>}/>
    )
}

export default DirectivoHeader
