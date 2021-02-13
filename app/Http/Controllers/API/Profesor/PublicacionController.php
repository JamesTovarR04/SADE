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
            'foto',
            'nlikes',
            'ndislikes'
            )->where('docentes', 1)
            ->orWhere('idUsuario', $request->user()->idUsuario)
            ->orderBy('fecha','desc')
            ->paginate(4);

        return response()->json($publicaciones);

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
