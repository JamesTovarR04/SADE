<?php

namespace App\Http\Controllers\API\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    
    /**
     * Actualizar Datos
     * 
     * @param Request $request
     */
    public function update(Request $request){

        $validacion = Validator::make($request->all(),[
            'direccion'     => 'string|max:45',
            'email'         => 'unique:directivo.usuarios,email|email|max:45',
            'contrasena'    => 'string|min:5|max:40'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $contrasena = NULL;
        if($request['contrasena'] != '')
            $contrasena = Hash::make($request['contrasena']);

        DB::connection('estudiante')
            ->select('CALL p_est_updateDatos(?,?,?,?)',[
                $request->user()->idUsuario,
                $request['direccion'],
                $request['email'],
                $contrasena
            ]);

        return response()->json([
            'message'   => 'Se actualizaron los datos.'
        ]);

    }

    /**
     * Ver mis datos
     * 
     * @param Request $request
     */
    public function show(Request $request){

        $datos['datos'] = DB::connection('estudiante')
            ->select('p_est_verDatosEstudiante(?)',[$request->user()->idUsuario]);

        $datos['telefonos'] = DB::connection('estudiante')
            ->select('p_est_verTelefonos(?)',[$request->user()->idUsuario]);

        return response()->json($datos);

    }

}
