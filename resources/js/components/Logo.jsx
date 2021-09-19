import React from 'react'
import propTypes from 'prop-types'

function Logo({
    white = false,
    height,
    width,
}) {
    const src = `/images/logo-${white ? 'blanco' : 'azul'}.svg`
    return <img src={src} height={height} width={width} className="d-inline-block align-top" alt="SADE"/>
}

Logo.propTypes = {
    white: propTypes.bool,
    height: propTypes.string,
    width: propTypes.string
}
export default Logo