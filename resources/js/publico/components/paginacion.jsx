import React from "react"

const Paginacion = (props) => {

    const items = []
    const maxLink = 8

    if(props.last > maxLink){
        var inicio = 1;
        var fin = maxLink;
        if(props.current > (maxLink/2) && props.current <= (props.last-(maxLink/2))){
            inicio = props.current - ((maxLink/2)-1)
            fin = props.current + (maxLink/2)
        }
        if(props.current > (props.last-(maxLink/2))){
            inicio = props.last-maxLink+1
            fin = props.last
        }
        for(var i=inicio; i<=fin; i++){
            items.push(<li className={i==props.current?'page-item active':'page-item'} key={i}>
                    <button value={i} className="page-link" onClick={e => props.pagina(e.target.value)}>{i}</button>
                </li>)
        }
    }else{
        for(var i=1; i<=props.last; i++){
            items.push(<li className={i==props.current?'page-item active':'page-item'} key={i}>
                    <button value={i} className="page-link" onClick={e => props.pagina(e.target.value)}>{i}</button>
                </li>)
        }
    }

    if(!(props.last > 1)){
        return null
    }

    return (
        <nav aria-label="Page navigation example">
            <ul className="pagination justify-content-center mb-0">
                <li className={(props.current==1)?'page-item disabled':'page-item'}>
                    <button className="page-link"
                    onClick={e => props.pagina(props.current-1)} 
                    aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </button>
                </li>
                {items}
                <li className={(props.current==props.last)?'page-item disabled':'page-item'}>
                    <button className="page-link"
                    onClick={e => props.pagina(props.current+1)} 
                    aria-label="Previous">
                        <span aria-hidden="true">&raquo;</span>
                    </button>
                </li>
            </ul>
        </nav>
    )

}

export default Paginacion