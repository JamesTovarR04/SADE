<?php

namespace App\Http\Controllers\API\Estudiante;

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
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     * agregar publicacion
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'titulo' =>'required|string|max:150',
            'contenido' =>'required|string|max:1000',
            'estudiante'=>'required|boolean',
            'directivo'=> 'required|boolean',
            'profesor'=>'required|boolean',
            'idUsuario' =>'required|integer',
        ]);

        if($validacion->fails()){
            return response (['error' => $validacion -> errors()->all()], 422);
        }

        $opcionesPrivacidad=[
            $request ['estudiante'],
            $request ['profesor'],
            $request ['directivo']
        ];

        $idPrivacidad = DB::connection('estudiante')->select('Select getIdPrivacidad(0,?,?,?) AS IdPrivacidad', $opcionesPrivacidad)[0]->idPrivacidad;


        return response ($idPrivacidad);    
       /*$publicacion = [
            'titulo',
            'contenido',
            'privacidad',
            'idUsuario',
        ];

        DB::connection('estudiante')
        ->select('CALL p_est_addPublicacion(?,?,?,?,NULL)',$publicacion); 

        return response ()->json(['message'=>'Publicado con exito']);*/
    
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
