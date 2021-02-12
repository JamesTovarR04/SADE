<?php

namespace App\Http\Controllers\API\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class GrupoController extends Controller
{
    //ver varios grupos
    public function index (Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'buscar' => 'string|min:1|max:100',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if($request['buscar'] == '')
            $grados = DB::connection('estudiante')
                ->table('grupos')
                ->get();
        else
            $grados = DB::connection('estudiante')
                ->select('CALL p_est_buscarGrupo(?)',[$request['buscar']]);


        return response()->json($grados);  

    }
    //ver grupo
    public function show ($idGrupo)
    {
        $grupo['info'] = DB::connection('estudiante')
            ->table('grupos')
            ->where('idGrupo',$idGrupo)
            ->first();

        if(is_null($grupo['info']))
            return response()->json([
                'message'   => 'No existe este grupo.'
            ],404);

        $grupo['director'] = DB::connection('estudiante')
            ->table('vs_est_infodocentes')
            ->where('idUsuario',$grupo['info']->director)
            ->first();

        $grupo['profesores'] = DB::connection('estudiante')
            ->table('vs_est_gradosdocentes')
            ->where('idGrupo',$idGrupo)
            ->get();

        $grupo['estudiantes'] = DB::connection('estudiante')
            ->table('vs_est_infoestudiantes')
            ->where('idGrupo',$idGrupo)
            ->get();

        return response()->json($grupo);

    }

    //ver mi grupo
    public function miGrupo (Request $request)
    {
        //pendiente esta madre :v
        
    }
}
