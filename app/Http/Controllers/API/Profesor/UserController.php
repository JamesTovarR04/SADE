<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    //Actualizar datos

    public function update(Request $request){


        $validacion = Validator::make($request->all(),[
            'direccion' =>        'string|max:45',
            'perfil' =>           'string|max:254',
            'email' =>            'unique:directivo.usuarios,email|email|max:45',
            'contrasena' =>       'string|max:40'       
        ]);

        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        //Validación de contraseña encriptada
        $contrasena = NULL;
        if($request['contrasena'] != '')
            $contrasena = Hash::make($request['contrasena']);

        DB::connection('profesor')
            ->select('CALL p_prf_updateDatos(?,?,?,?,?)',[
            $request->user()->idUsuario,
            $request['direccion'],
            $request['perfil'],
            $request['email'],
            $contrasena
        ]);

        return response()->json(['message'=>'Se actualizaron los datos']);

    }


    public function show(Request $request){

        $datos['datos'] = DB::connection('profesor')
            ->select('CALL p_prf_verDatosDocente(?)', [$request->user()->idUsuario]);

        $datos['telefonos'] = DB::connection('profesor')
            ->select('CALL p_prf_verTelefonos(?)',[$request->user()->idUsuario]);

        return response()->json($datos);
    }

}
