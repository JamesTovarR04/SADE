<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PublicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
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
            $publicaciones = DB::connection('directivo')
                ->table('vs_publicaciones')
                ->select(
                    'idPublicacion',
                    'titulo',
                    'contenido',
                    'fecha',
                    'vs_publicaciones.idUsuario',
                    'nombreCompleto',
                    'tipo',
                    'nlikes',
                    'ndislikes',
                    DB::raw("EXISTS(SELECT * FROM Likes l WHERE l.idPublicacion=vs_publicaciones.idPublicacion AND l.idUsuario=$idUsuario) AS conlike"),
                    DB::raw("EXISTS(SELECT * FROM Dislike d WHERE d.idPublicacion=vs_publicaciones.idPublicacion AND d.idUsuario=$idUsuario) AS condislike")
                )->where('directivos',1)
                ->orWhere('vs_publicaciones.idUsuario',$idUsuario)
                ->orderBy('fecha', 'desc')
                ->paginate(5);
        else
            $publicaciones = DB::connection('directivo')
                ->select('CALL p_dir_buscarPublicacion(?)',[$request['buscar']]);

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
        $publicaciones = DB::connection('directivo')
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
        $privacidad = DB::connection('directivo')
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

        $like = DB::connection('directivo')
            ->table('likes')
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$idUsuario)
            ->first();

        if(is_null($like)){
            DB::connection('directivo')
                ->table('likes')
                ->insert([
                    'idPublicacion' => $idPublicacion,
                    'idUsuario'     => $idUsuario
                ]);
        }else{
            DB::connection('directivo')
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

        $like = DB::connection('directivo')
            ->table('dislike')
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$idUsuario)
            ->first();

        if(is_null($like)){
            DB::connection('directivo')
                ->table('dislike')
                ->insert([
                    'idPublicacion' => $idPublicacion,
                    'idUsuario'     => $idUsuario
                ]);
        }else{
            DB::connection('directivo')
                ->table('dislike')
                ->where('idPublicacion',$idPublicacion)
                ->where('idUsuario',$idUsuario)
                ->delete();
        }

        return response()->json([
            'dislike'  => is_null($like)
        ]);

    }

    /**
     * Agregar publicacion.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'titulo'    => 'required|string|max:150',
            'contenido' => 'required|string|max:1000',
            'publico'   => 'required|boolean',
            'directivo' => 'required|boolean',
            'profesor'  => 'required|boolean',
            'estudiante'=> 'required|boolean'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $opcionesPrivacidad = [
            $request['publico'],
            $request['directivo'],
            $request['profesor'],
            $request['estudiante']
        ];

        $positivos = 0;
        foreach ($opcionesPrivacidad as $value)
            if($value == 1) $positivos++;

        if($positivos == 0)
            $idPrivacidad = 8;
        else
            $idPrivacidad = DB::connection('directivo')->select('SELECT getIdPrivacidad(?,?,?,?) AS idPrivacidad',$opcionesPrivacidad)[0]->idPrivacidad;

        $publicacion = [
            'titulo'        => $request['titulo'],
            'contenido'     => $request['contenido'],
            'fecha'         => date("Y-m-d H:i:s"),
            'idUsuario'     => $request->user()->idUsuario,
            'idPrivacidad'  => $idPrivacidad,
        ];

        DB::connection('directivo')
            ->table('publicaciones')->insert($publicacion);

        return response()->json(['message'=>'Publicado con éxito'],201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return response()->json(['message'=>'Estamos trabajando en esto :/'],404);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $idPublicacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idPublicacion)
    {
        $validacion = Validator::make($request->all(),[
            'titulo'    => 'required|string|max:150',
            'contenido' => 'required|string|max:1000'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        DB::connection('directivo')
            ->table('publicaciones')
            ->where('idPublicacion',$idPublicacion)
            ->where('idUsuario',$request->user()->idUsuario)
            ->update([
                'titulo'    => $request['titulo'],
                'contenido' => $request['contenido']
            ]);

        return response()->json(['message' => 'Se actualizó la publicación']);

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $idPublicacion
     * @return \Illuminate\Http\Response
     */
    public function destroy($idPublicacion)
    {
        $afectado = DB::connection('directivo')
            ->table('publicaciones')->where('idPublicacion', $idPublicacion)->delete();
        
        if($afectado > 0)
            return response()->json([
                'message'   => 'La publicacion fue eliminada.'
            ]);
        else
            return response()->json([
                'message'   => 'No existe la publicación.'
            ],404);
    }
}
