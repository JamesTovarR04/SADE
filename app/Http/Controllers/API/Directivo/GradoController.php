<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Symfony\Component\Console\Output\NullOutput;

class GradoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'buscar' => 'string|min:1|max:100',
            'colorden'  => Rule::in(['nombre','jornada','salon']),
            'orden'     => Rule::in(['asc','desc']),
            'grado'     => 'integer'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if($request['buscar'] == ''){
            $columna = ($request['colorden'] == '') ? 'idGrupo' : $request['colorden'];
            $orden = ($request['orden'] == '') ? 'asc' : $request['orden'];
            $grado = ($request['grado'] == '') ? '0' : $request['grado'];
            $comparar = ($request['grado'] == '') ? '>=' : '=';
            $grados = DB::connection('directivo')
                ->table('grupos')
                ->where('grado',$comparar,$grado)
                ->orderBy($columna, $orden)
                ->get();
        }else
            $grados = DB::connection('directivo')
                ->select('CALL p_dir_buscarGrupo(?)',[$request['buscar']]);


        return response()->json($grados);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'nombre'    => 'required|string|max:10',
            'jornada'   => ['required', Rule::in(['Mañana', 'Tarde', 'Nocturno', 'Mixto'])],
            'salon'     => 'required|string',
            'grado'     => 'required|integer|min:0|max:15',
            'director'  => 'exists:directivo.docentes,idUsuario'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $grupo = [
            'nombre'    => $request['nombre'],
            'jornada'   => $request['jornada'],
            'salon'     => $request['salon'],
            'grado'     => $request['grado'],
            'director'  => $request['director']
        ];

        $idGrupo = DB::connection('directivo')
            ->table('grupos')->insertGetId($grupo);

        return response()->json([
            'message'   =>'Se agregó el grado grado'.$request['nombre'],
            'id'        => $idGrupo
        ],201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($idGrupo)
    {
        $grupo['info'] = DB::connection('directivo')
            ->table('grupos')
            ->where('idGrupo',$idGrupo)
            ->first();

        if(is_null($grupo['info']))
            return response()->json([
                'message'   => 'No existe este grupo.'
            ],404);

        $grupo['director'] = DB::connection('directivo')
            ->table('vs_infodocentes')
            ->where('idUsuario',$grupo['info']->director)
            ->first();

        $grupo['profesores'] = DB::connection('profesor')
            ->table('vs_prf_gradosdocentes')
            ->where('idGrupo',$idGrupo)
            ->get();

        $grupo['estudiantes'] = DB::connection('directivo')
            ->table('vs_infoestudiantes')
            ->where('idGrupo',$idGrupo)
            ->get();

        return response()->json($grupo);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idGrupo)
    {
        $validacion = Validator::make($request->all(),[
            'jornada'   => ['required', Rule::in(['Mañana', 'Tarde', 'Nocturno', 'Mixto'])],
            'salon'     => 'required|string',
            'grado'     => 'required|integer|min:0|max:15',
            'director'  => 'exists:directivo.docentes,idUsuario'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $afectado = DB::connection('directivo')
            ->table('grupos')
            ->where('idGrupo',$idGrupo)
            ->update([
                'jornada'   => $request['jornada'],
                'salon'     => $request['salon'],
                'grado'     => $request['grado'],
                'director'  => $request['director']
            ]);

        if($afectado > 0)
            return response()->json([
                'message'   => 'El grupo fue actualizado.'
            ]);
        else
            return response()->json([
                'message'   => 'No existe el grupo.'
            ],404);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function addProfesor(Request $request, $idGrupo)
    {
        $validacion = Validator::make($request->all(),[
            'idProfesor'  => 'exists:directivo.docentes,idUsuario'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $afectado = DB::connection('directivo')
            ->table('GruposDocentes')->insertOrIgnore([
                'idGrupo' => $idGrupo, 
                'idDocente' => $request['idProfesor']
            ]);

        if($afectado > 0)
            return response()->json([
                'message'   => 'Se agregó el profesor.'
            ]);
        else
            return response()->json([
                'message'   => 'No existe el grupo o el profesor ya esta en este grupo.'
            ],404);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($idGrupo)
    {
        $afectado = DB::connection('directivo')
            ->table('grupos')->where('idGrupo', $idGrupo)->delete();
        
        if($afectado > 0)
            return response()->json([
                'message'   => 'El grupo fue eliminado.'
            ]);
        else
            return response()->json([
                'message'   => 'No existe el grupo.'
            ],404);
    }
}
