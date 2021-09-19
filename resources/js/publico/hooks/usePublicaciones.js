import { useEffect, useState } from "react"

const usePublicaciones = () => {
    const [publicaciones,setPublicaciones] = useState([])
    const [cargando, setCargando] = useState(true)
    const [error, setError] = useState(false)
    const [page, setPage] = useState(1)

    useEffect(() => {
        setCargando(true)
        setError(false)
        axios.get('/api/publico/publicaciones?page=' + page)
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
    }, [page])

    return [publicaciones, cargando, error, setPage]
}

export default usePublicaciones