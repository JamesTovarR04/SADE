import React, { useState, useEffect } from 'react'
import propTypes from 'prop-types'

/* Calendario de eventos
*
*   props:
*       fechas: Array(Objs), objExamp: {dia:5, eventos:7}
*       clickDia: func(year,month,day)
*       cambioMes: func(year,month)
*/
const Calendario = (props) => {

    let today = new Date()

    const[year,setYear] = useState(today.getFullYear())
    const[month,setMonth] = useState(today.getMonth())
    //const[day,setDay] = useState(today.getDate())
    const[hoy,setHoy] = useState(today.getFullYear()+'/'+today.getMonth()+'/'+today.getDate())
    const[tabla,setTabla] = useState([])
    const[fechas,setFechas] = useState([])

    // Crea la tabla de calendarios
    useEffect(() => {
        const diasMes         = new Date(year,month + 1,0).getDate()
        // const diasMesAnterior = new Date(year,month,0).getDate()
        const diaInicio       = new Date(year,month,1).getDay()

        var tablaMes = new Array()

        var dia = 1
        var inicia = false
        var fin = false;
        var semana = 0
        semana: while( !fin ){
            tablaMes[semana] = new Array()
            dia: for (var i = 0; i < 7; i++) {
                if(diaInicio == i && !inicia)
                    inicia = true

                if(inicia){
                    if(dia > diasMes){
                        fin = true
                        tablaMes[semana][i] = -1
                    }else{
                        tablaMes[semana][i] = dia
                        dia++
                    }
                    continue dia
                }

                tablaMes[semana][i] = -1
            }
            if(dia > diasMes){
                break semana
            }
            semana++
        }
        setTabla(tablaMes)
    },[month,year])


    // Establecer las fechas
    useEffect(() => {
        var listaFechas = []
        if(props.fechas !== undefined){
            props.fechas.forEach(fecha => {
                let color = "#2f9728";
                if(fecha.Eventos > 5)
                    color = "#d11d14";
                else if(fecha.Eventos > 3)
                    color = "#e06414";
                listaFechas[fecha.Dia] = color;
            })
            setFechas(listaFechas);
        }
    },[props.fechas,month])

    // cambio mes
    useEffect(() => {
        if(props.cambioMes !== undefined)
            props.cambioMes(year,month + 1)
    },[month])

    // Click en siguiente mes
    function nextMonth(){
        if(month == 11){
            setYear(year + 1)
            setMonth(0)
        }else{
            setMonth(month + 1)
        }
    }

    // Click en mes anterior
    function prevMonth(){
        if(month == 0){
            setYear(year - 1)
            setMonth(11)
        }else{
            setMonth(month - 1)
        }
    }

    // Click en día
    function clickDay(year,month,day){
        if(props.clickDia !== undefined)
            props.clickDia(year,month,day)
    }

    function mesesESP(mes){
        const meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        return meses[mes]
    }

    return (
        <div className='calendario'>
            <div className='calendario-header' style={fila}>
                <div>
                    <button onClick={() => prevMonth()} className='calendario-btn-change'>
                        <i className="fas fa-chevron-left"></i>
                    </button>
                </div>
                <div style={{flexGrow:1, textAlign:'center'}}>
                    <h4>{mesesESP(month) + ' ' + year}</h4>
                </div>
                <div>
                    <button onClick={() => nextMonth()} className='calendario-btn-change'>
                        <i className="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
            <div className='calendario-body'>
                <div className='calendario-week-header' style={fila}>
                    <div style={celdas}>Dom</div>
                    <div style={celdas}>Lun</div>
                    <div style={celdas}>Mar</div>
                    <div style={celdas}>Mié</div>
                    <div style={celdas}>Juv</div>
                    <div style={celdas}>Vie</div>
                    <div style={celdas}>Sáb</div>
                </div>
                {tabla.map(week =>
                    <div key={week[0]} className='calendario-week' style={fila}>
                        {week.map((d,i,a) => (d == -1)? <div key={i} style={celdas}></div> :
                            <div key={i} className='calendario-day' style={celdas}>
                                <button
                                className={(hoy == (year+'/'+month+'/'+d))?'calendario-today':''}
                                style={(fechas[d] === undefined)?{}:{borderBottom: 4 +'px solid '+fechas[d]}}
                                onClick={() => clickDay(year,month+1,d)}>
                                    {d}
                                </button>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    )

}

const fila = {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center'
}

const celdas= {
    width: 14.28 + '%',
    textAlign: 'center'
}

Calendario.propTypes = {
    fechas: propTypes.array, 
    cambioMes: propTypes.func, 
    clickDia: propTypes.func
}

export default Calendario