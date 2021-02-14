<?php

namespace App\Http\Controllers\API\Profesor;

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
            $grados = DB::connection('profesor')
                ->table('grupos')
                ->get();
        else
            $grados = DB::connection('profesor')
                ->select('CALL p_pfr_buscarGrupo(?)',[$request['buscar']]);


        return response()->json($grados);  

    }
    //ver grupo
    public function show (Request $request, $idGrupo)
    {
        $grupo['info'] = DB::connection('profesor')
            ->table('grupos')
            ->where('idGrupo',$idGrupo)
            ->first();

        if(is_null($grupo['info']))
            return response()->json([
                'message'   => 'No existe este grupo.'
            ],404);

        $grupo['director'] = DB::connection('profesor')
            ->table('vs_prf_infodocentes')
            ->where('idUsuario',$grupo['info']->director)
            ->first();

        $grupo['profesores'] = DB::connection('profesor')
            ->table('vs_prf_gradosdocentes')
            ->where('idGrupo',$idGrupo)
            ->get();

        $grupoClase = DB::connection('profesor')
            ->table('vs_prf_gradosdocentes')
            ->where('idGrupo',$idGrupo)
            ->where('idUsuario',$request->user()->idUsuario)
            ->first();

        if(is_null($grupoClase))
            $grupo['estudiantes'] = DB::connection('profesor')
                ->table('vs_prf_infoestudiantes')
                ->where('idGrupo',$idGrupo)
                ->get();
        else
            $grupo['estudiantes'] = DB::connection('profesor')
                ->table('vs_prf_estudiantesclase')
                ->where('idGrupo',$idGrupo)
                ->get();

        return response()->json($grupo);
    }
}
