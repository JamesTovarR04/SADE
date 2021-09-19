import { useEffect, useState } from "react";

const useEventos = () => {

    let today = new Date();

    const [fechas,setFechas] = useState([]);
    const [dia, setDia] = useState(today.getDate());
    const [mes, setMes] = useState(today.getMonth());
    const [ano, setAno] = useState(today.getFullYear());
    const [cargando, setCargando] = useState(true);
    const [eventos, setEventos] = useState([]);
    const [error, setError] = useState(false)

    useEffect(() => {
        obtenerEventos(ano,mes,dia)
    },[dia]);

    function obtenerEventos(year,month,day){
        month++;
        let mes = (month < 10 ? '0' : '') + month;
        let dia = (day < 10  ? '0' : '') + day;
        setCargando(true)
        setError(false)
        axios.get('/api/publico/eventos', {
            params: {'dia' : year + '-' + mes + '-' + dia}
        })
        .then((response) => {
            // handle success
            if(response.headers["content-type"] == "application/json" && response.data !== undefined){
                setEventos(response.data)
                setCargando(false)
            }
            setError(true)
        })
        .catch((error) => {
            setError(true)
        })
    }

    function obtenerFechas(year,month){
        let data = {
            'mes' : year + '-' + (month < 10 ? '0' : '') + month,
        }
        axios.get('/api/publico/eventos/mes', {
            params: data
        })
        .then((response) => {
            // handle success
            if(response.headers["content-type"] == "application/json" && response.data !== undefined){
                setFechas(response.data)
            }
        })
        .catch((error) => {
        })
    }

    function clickDia(year,month,day){
        setDia(day);
        setMes(month-1);
        setAno(year);
        //obtenerEventos(year,month,day)
    }

    function cambioMes(year,month){
        obtenerFechas(year,month)
    }

    return [fechas, clickDia, cambioMes, dia, mes, eventos, cargando, error]

}

export default useEventos