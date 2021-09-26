import React, { useState, useContext } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'
import { GlobalContext } from '../context/GlobalState'

const BtnsLike = ({
    conlike = false,
    condislike = false,
    idPublicacion = -1,
    likes = 0,
    dislikes = 0
}) => {

    const { tipoUsuario } = useContext(GlobalContext)

    const [like, setLike] = useState(conlike)
    const [dislike, setDislike] = useState(condislike)
    const [totalLikes, setTotalLikes] = useState(likes)
    const [totalDislikes, setTotalDislikes] = useState(dislikes)

    const sendLike = () => {
        if(tipoUsuario == "publico") return false

        if(dislike) sendDislike()
        setLike(!like)
        if(like)
            setTotalLikes(totalLikes - 1)
        else
            setTotalLikes(totalLikes + 1)

        axios.get('/api/' + tipoUsuario + '/publicaciones/' + idPublicacion + '/like' )
        .then(res => {
            return true
        })
        .catch(err => {
            setLike(!like)
            setTotalLikes(likes)
            return false
        })
    }

    const sendDislike = () => {
        if(tipoUsuario == "publico") return false

        if(like) sendLike()
        setDislike(!dislike)
        if(dislike)
            setTotalDislikes(totalDislikes - 1)
        else
            setTotalDislikes(totalDislikes + 1)

        axios.get('/api/' + tipoUsuario + '/publicaciones/' + idPublicacion + '/dislike' )
        .then(res => {
            return true
        })
        .catch(err => {
            setDislike(!dislike)
            setTotalDislikes(dislikes)
            return false
        })
    }

    return (
        <div className="col d-flex justify-content-end align-items-center text-muted">
            <div onClick={sendLike} >
                <div className={"mr-2 d-inline-block " + (like && "text-danger")}>
                    <i className="fas fa-heart"></i>
                </div>
                <div className="mr-3 mb-1 d-inline-block">
                    {/* Likes */}
                    <span>{totalLikes}</span>
                </div>
            </div>
            <div onClick={sendDislike}>
                <div className={"mr-2 d-inline-block " + (dislike && "text-danger")}>
                    <i className="fas fa-heart-broken"></i>
                </div>
                <div className="mb-1 mr-3 d-inline-block">
                    {/* Dislikes */}
                    <span>{totalDislikes}</span>
                </div>
            </div>
        </div>
    )
}

BtnsLike.propTypes = {
    conlike: PropTypes.bool,
    condilike: PropTypes.bool,
    idPublicacion: PropTypes.number,
    likes: PropTypes.number,
    dislikes: PropTypes.number
}

export default BtnsLike
