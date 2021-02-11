<?php

namespace App\Http\Controllers\API\Publico;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class EventoController extends Controller
{
    
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'dia' => 'required|date_format:Y-m-d',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $eventos = DB::connection('publico')
            ->table('vs_pub_eventos')
            ->whereDate('hora', $request['dia'])
            ->get();

        return response()->json($eventos);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function enMes(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'mes' => 'required|date_format:Y-m',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $anhoMes = explode('-',$request['mes']);

        $anho = $anhoMes[0];
        $mes  = $anhoMes[1];

        $eventos = DB::connection('publico')
            ->select('CALL p_pub_eventosMes(?,?)',[$mes,$anho]);

        return response()->json($eventos);
    }

}
