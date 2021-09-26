import { useEffect, useState } from "react"

const usePublicaciones = (usuario) => {
    const [publicaciones,setPublicaciones] = useState([])
    const [cargando, setCargando] = useState(true)
    const [error, setError] = useState(false)
    const [page, setPage] = useState(1)

    useEffect(() => {
        cargarPublicaciones()
    }, [page])

    const cargarPublicaciones = () => {
        setCargando(true)
        setError(false)
        axios.get('/api/' + usuario + '/publicaciones?page=' + page)
        .then((response) => {
            // handle success
            if(response.headers["content-type"] == "application/json" && response.data !== undefined){
                setPublicaciones(response.data)
                setCargando(false)
            }
            setError(true)
        })
        .catch((error) => {
            setError(true)
        })
    }

    return [publicaciones, cargando, error, setPage, cargarPublicaciones]
}

export default usePublicaciones