<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class EventoController extends Controller
{
    
    public function index(Request $request)
    {

        $validacion = Validator::make($request->all(),[
            'dia' =>     'required|date_format:Y-m-d',        
        ]);
        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        $evento = DB::connection('profesor')
            ->table('vs_eventos')
            ->select(
            'idEventos',
            'hora',
            'descripcion',
            'idUsuario',
            'nombreCompleto',
            'tipo'
            )->where(function($query) use ($request){
                $query->where('docentes',1)
                    ->orWhere('idUsuario',$request->user()->idUsuario);
            })
            ->whereDate('hora', $request['dia'])
            ->orderBy('hora', 'asc')
            ->get();

        return response()->json($evento);
    }

  
    public function store(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'hora' =>       'required|date_format:Y-m-d H:i:s',
            'descripcion' =>'required|string|max:100', 
            'publico' =>    'required|boolean',
            'directivo' =>  'required|boolean',
            'profesor' =>   'required|boolean',
            'estudiante' => 'required|boolean',    
        ]);

        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }
        
        $opcionesPrivacidad = [
            $request['publico'],
            $request['directivo'],
            $request['profesor'],
            $request['estudiante']
        ];

        $positivos = 0;
        foreach ($opcionesPrivacidad as $value){
            if ($value == 1) $positivos++;
        }
        
        if($positivos == 0)
            $idPrivacidad = 8;
        else
            $idPrivacidad = DB::connection('profesor')->select('SELECT getIdPrivacidad(?,?,?,?) AS idPrivacidad',$opcionesPrivacidad)[0]->idPrivacidad;
        
        $eventos = [
            $request['hora'],
            $request['descripcion'],
            $request->user()->idUsuario, 
            $idPrivacidad,
                     
        ];
        DB::connection('profesor')
            ->select('CALL p_prf_addEvento(?,?,?,?)',$eventos);
            //->select('CALL p_prf_addEvento("2020-02-20 20:20:20","Prueba otra vez",482,1)',$eventos);
            
        return response()->json(['message'=>'Evento agregado']); 
    }

    
    public function show($id)
    {
        //
    }

    
    public function update(Request $request, $id)
    {
        //
    }

    
    public function destroy(Request $request, $idEvento)
    {
        DB::connection('profesor')
            ->select('CALL p_prf_deleteEvento(?,?)',[$idEvento, $request->user()->idUsuario]);

        return response()->json(['message'=> 'Se canceló el evento']);
    }
}
