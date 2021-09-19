import React, { memo } from 'react'
import PropTypes from 'prop-types'

const Button = ({
    cargando = false,
    text = "Button",
    addClass = "",
    type = "button",
    onClick = () => {}
}) => {
    return (
        <button 
        className={"btn " + (cargando && 'disabled') + " " + addClass} 
        type={type}
        onClick={onClick}
        >
            {cargando && <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>}
            <span className={cargando ? 'ml-2' : ''}>{text}</span>
        </button>
    )
}

Button.propTypes = {
    cargando: PropTypes.bool,
    text: PropTypes.string,
    addClass: PropTypes.string,
    onClick: PropTypes.func
}

export default memo(Button)
