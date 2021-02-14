<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class EstudiantesController extends Controller
{
    
    /**
     * Listado de estudiantes de un grupo del profesor director
     * 
     * @param Request $request
     * @param int idGrupo
     * 
     * @return response
     */
    public function listadoGrupoDirectivo(Request $request, $idGrupo){

        $validacion = Validator::make($request->all(),[
            'buscar'    => 'string|min:3|max:100',
            'colorden'  => Rule::in(['nombres','apellido1','apellido2','RH','numeroDocumento','sexo','fechaNacimiento']),
            'orden'     => Rule::in(['asc','desc'])
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $director = DB::connection('profesor')
            ->table('grupos')
            ->where('idGrupo',$idGrupo)
            ->where('director',$request->user()->idUsuario)
            ->first();

        if(!is_null($director)){
            $buscar = $request['buscar'];
            $columna = ($request['colorden'] == '') ? 'idUsuario' : $request['colorden'];
            $orden = ($request['orden'] == '') ? 'asc' : $request['orden'];
            $estudiantes = DB::connection('profesor')
                ->table('vs_prf_estudiantesdirector')
                ->where('idGrupo',$idGrupo)
                ->where(function ($query) use ($buscar) {
                    $query->where('nombres','like',$buscar.'%')
                        ->orWhere('apellido1','like',$buscar.'%')
                        ->orWhere('apellido2','like',$buscar.'%')
                        ->orWhere('email','like',$buscar.'%')
                        ->orWhere('numeroDocumento','like',$buscar.'%')
                        ->orWhere('telefono','like',$buscar.'%');
                })
                ->orderBy($columna, $orden)
                ->paginate(25);
        } else{
            return response()->json([
                'message'   => 'No eres director de este grupo.'
            ],404);
        }

        return response()->json($estudiantes);

    }

    /**
     * Listado de estudiantes de un grupo del profesor director
     * 
     * @param Request $request
     * @param int idGrupo
     * 
     * @return response
     */
    public function listadoGrupo(Request $request, $idGrupo){

        $validacion = Validator::make($request->all(),[
            'buscar'    => 'string|min:3|max:100',
            'colorden'  => Rule::in(['nombres','apellido1','apellido2','RH']),
            'orden'     => Rule::in(['asc','desc'])
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $grupoClase = DB::connection('profesor')
            ->table('vs_prf_gradosdocentes')
            ->where('idGrupo',$idGrupo)
            ->where('idUsuario',$request->user()->idUsuario)
            ->first();

        if(!is_null($grupoClase)){
            $buscar = $request['buscar'];
            $columna = ($request['colorden'] == '') ? 'idUsuario' : $request['colorden'];
            $orden = ($request['orden'] == '') ? 'asc' : $request['orden'];
            $estudiantes = DB::connection('profesor')
                ->table('vs_prf_estudiantesclase')
                ->where('idGrupo',$idGrupo)
                ->where(function ($query) use ($buscar) {
                    $query->where('nombres','like',$buscar.'%')
                        ->orWhere('apellido1','like',$buscar.'%')
                        ->orWhere('apellido2','like',$buscar.'%')
                        ->orWhere('email','like',$buscar.'%');
                })
                ->orderBy($columna, $orden)
                ->paginate(25);
        } else{
            return response()->json([
                'message'   => 'No eres profesor de este grupo.'
            ],404);
        }

        return response()->json($estudiantes);

    }

}
