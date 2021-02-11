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
                'foto',
                'nlikes',
                'ndislikes'
            )->where('directivos',1)
            ->orWhere('idUsuario',$request->user()->idUsuario)
            ->orderBy('fecha', 'desc')
            ->paginate(4);

        return response()->json($publicaciones);
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

        return response()->json(['message'=>'Publicado con éxito']);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return response()->json(['message'=>'Estamos trabajando en esto :/']);
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
        DB::connection('directivo')
            ->table('publicaciones')->where('idPublicacion', $idPublicacion)->delete();
        
        return response()->json(['message' => 'Se borró la publicación']);
    }
}
