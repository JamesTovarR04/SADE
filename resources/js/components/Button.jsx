import React, { memo } from 'react'
import PropTypes from 'prop-types'

const Button = ({
    cargando = false,
    text = "Button",
    addClass = "",
    type = "button",
    onClick = () => {},
    disabled = false,
    icon = ""
}) => {
    return (
        <button 
        className={"btn " + (cargando && 'disabled') + " " + addClass} 
        type={type}
        onClick={onClick}
        disabled={disabled}
        >
            {cargando &&
            <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
            }
            <span className={cargando ? 'ml-2' : ''}>
                {icon != "" &&
                <i className={icon + " mr-2"}></i>
                }
                {text}
            </span>
        </button>
    )
}

Button.propTypes = {
    cargando: PropTypes.bool,
    text: PropTypes.string,
    addClass: PropTypes.string,
    onClick: PropTypes.func,
    disabled: PropTypes.bool,
    icon: PropTypes.string
}

export default memo(Button)
