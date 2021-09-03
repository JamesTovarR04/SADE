<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PublicacionController extends Controller
{

    //Mostrar Publicacion
    public function index(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'buscar' => 'string|min:4|max:100',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $idUsuario = $request->user()->idUsuario;

        if($request['buscar']=='')
            $publicaciones = DB::connection('profesor')
                ->table('vs_publicaciones')
                ->select(
                    'idPublicacion',
                    'titulo',
                    'contenido',
                    'fecha',
                    'idUsuario',
                    'nombreCompleto',
                    'tipo',
                    'nlikes',
                    'ndislikes',
                    DB::raw("EXISTS(SELECT * FROM Likes l WHERE l.idPublicacion=vs_publicaciones.idPublicacion AND l.idUsuario=$idUsuario) AS conlike"),
                    DB::raw("EXISTS(SELECT * FROM Dislike d WHERE d.idPublicacion=vs_publicaciones.idPublicacion AND d.idUsuario=$idUsuario) AS condislike")
                )->where('docentes', 1)
                ->orWhere('idUsuario',$idUsuario)
                ->orderBy('fecha', 'desc')
                ->paginate(5);
        else
            $publicaciones = DB::connection('profesor')
                ->select('CALL p_prf_buscarPublicacion(?)',[$request['buscar']]);

        return response()->json($publicaciones);

    }

    /**
     * Ver publicaciones de usuario.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function delUsuario(Request $request)
    {
        $publicaciones = DB::connection('profesor')
            ->table('vs_publicaciones')
            ->select(
                'idPublicacion',
                'titulo',
                'contenido',
                'fecha',
                'idUsuario',
                'nombreCompleto',
                'tipo',
                'nlikes',
                'ndislikes'
            )
            ->where('idUsuario',$request->user()->idUsuario)
            ->orderBy('fecha', 'desc')
            ->paginate(5);

        return response()->json($publicaciones);
    }

    /**
     * Ver privacidad de publicaciones de usuario.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $idPublicacion
     * @return \Illuminate\Http\Response
     */
    public function privacidad(Request $request, $idPublicacion)
    {
        $privacidad = DB::connection('profesor')
            ->table('vs_publicaciones')
            ->select(
                'publico',
                'directivos',
                'docentes',
                'estudiantes'
            )
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$request->user()->idUsuario)
            ->first();
        
        if(!is_null($privacidad))
            return response()->json($privacidad);
        else
            return response()->json([
                'message'   => 'No existe la publicación.'
            ],404);
    }

    /**
     * Like a publicacion.
     * 
     * FEXME: el usuario puede dar like a cualquier publicacion
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $idPublicacion
     * @return \Illuminate\Http\Response
     */
    public function like(Request $request, $idPublicacion)
    {
        $idUsuario = $request->user()->idUsuario;

        $like = DB::connection('profesor')
            ->table('likes')
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$idUsuario)
            ->first();

        if(is_null($like)){
            DB::connection('profesor')
                ->table('likes')
                ->insert([
                    'idPublicacion' => $idPublicacion,
                    'idUsuario'     => $idUsuario
                ]);
        }else{
            DB::connection('profesor')
                ->table('likes')
                ->where('idPublicacion',$idPublicacion)
                ->where('idUsuario',$idUsuario)
                ->delete();
        }

        return response()->json([
            'like'  => is_null($like)
        ]);

    }

    /**
     * disLike a publicacion.
     * 
     * FEXME: el usuario puede dar dislike a cualquier publicacion
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $idPublicacion
     * @return \Illuminate\Http\Response
     */
    public function dislike(Request $request, $idPublicacion)
    {
        $idUsuario = $request->user()->idUsuario;

        $like = DB::connection('profesor')
            ->table('dislike')
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$idUsuario)
            ->first();

        if(is_null($like)){
            DB::connection('profesor')
                ->table('dislike')
                ->insert([
                    'idPublicacion' => $idPublicacion,
                    'idUsuario'     => $idUsuario
                ]);
        }else{
            DB::connection('profesor')
                ->table('dislike')
                ->where('idPublicacion',$idPublicacion)
                ->where('idUsuario',$idUsuario)
                ->delete();
        }

        return response()->json([
            'dislike'  => is_null($like)
        ]);

    }

    //Agregar Publicacion
    public function store(Request $request)
    {
        
        $validacion = Validator::make($request->all(),[
            'titulo' =>     'required|string|max:150',
            'contenido' =>  'required|string|max:1000',
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
        
        $publicacion = [
            $request['titulo'],
            $request['contenido'],
            $idPrivacidad,
            $request->user()->idUsuario, 
            date("Y-m-d H:i:s")
        ];
        DB::connection('profesor')
            ->select('CALL p_prf_addPublicacion(?,?,?,?,?)',$publicacion);
        return response()->json(['message'=>'Publicado con éxito'],201); 

    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    
    /* public function show($id)
    {
        
    } */

   

    public function update(Request $request, $idPublicacion)
    {

        $validacion = Validator::make($request->all(),[
            'titulo' =>     'required|string|max:150',
            'contenido' =>  'required|string|max:1000', 
        ]);
        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        $opciones = [
            $idPublicacion, 
            $request->user()->idUsuario,
            $request['titulo'],
            $request['contenido']
        ];
        DB::connection('profesor')
            ->select('CALL p_prf_editPublicacion(?,?,?,?)',$opciones);
        return response()->json(['message' => 'Se actualizó la publicación']);
    }



    public function destroy(Request $request, $idPublicacion)
    {
        DB::connection('profesor')
            ->select('CALL p_prf_deletePublicacion(?,?)',[$idPublicacion, $request->user()->idUsuario]);

        return response()->json(['message'=> 'Se borró la publicacion']);
    }

}
