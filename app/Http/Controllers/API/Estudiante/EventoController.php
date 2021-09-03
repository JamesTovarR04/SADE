<?php

namespace App\Http\Controllers\API\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class EventoController extends Controller
{
    //Mostrar Evento
    public function index(Request $request)
    {

        $validacion = Validator::make($request->all(),[
            'dia' =>     'required|date_format:Y-m-d',        
        ]);
        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        $evento = DB::connection('estudiante')
            ->table('vs_eventos')
            ->select(
            'idEventos',
            'hora',
            'descripcion',
            'idUsuario',
            'nombreCompleto',
            'tipo'
            )->where(function($query) use ($request){
                $query->where('estudiantes',1)
                    ->orWhere('idUsuario',$request->user()->idUsuario);
            })
            ->whereDate('hora', $request['dia'])
            ->orderBy('hora', 'asc')
            ->get();

        return response()->json($evento);
    }

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

        $eventos = DB::connection('estudiante')
            ->select('CALL p_est_eventosMes(?,?,?)',[$request->user()->idUsuario,$mes,$anho]);

        return response()->json($eventos);
    }
} 