<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    
    /**
    * Inicio de sesión y creacion de token
    */

    public function login(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'user' => 'required|string',
            'password' => 'required|string',
            'remember_me' => 'boolean'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        /**
         * Llamar a procedimiento para buscar idUusario por email o numero de documento
         */
        $dataLogin = DB::select('CALL p_pub_login(?)',[$request['user']]);

        if(count($dataLogin)==0){
            return response()
                    ->json([
                        'code'=>2,
                        'Message'=>'Usuario o contraseña incorrectos.'
                    ], 401);
        }

        if($dataLogin[0]->intentosConexion == 8){
            return response()
                    ->json([
                        'code'=>3,
                        'Message'=>'El usuario fue bloqueado por realizar demasiados intentos sin exito.'
                    ], 401);
        }

        $credentials = ['idUsuario'=>$dataLogin[0]->idUsuario,'password'=>$request['password']];

        if (!Auth::attempt($credentials))
            return response()->json([
                'code'=>2,
                'Message'=>'Usuario o contraseña incorrectos.'
            ], 401);

        // Reiniciar conteo de intentos
        DB::table('Usuarios')
            ->where('idUsuario',$dataLogin[0]->idUsuario)
            ->update([
                'intentosConexion' => 0
            ]);

        $user = $request->user();
        $tokenResult = $user->createToken('Personal Access Token');

        $token = $tokenResult->token;
        if ($request->remember_me)
            $token->expires_at = Carbon::now()->addWeeks(1);
        $token->save();

        return response()->json([
            'rol'           => $user->rol(),
            'usuario'       => $user->nombres,
            'access_token'  => $tokenResult->accessToken,
            'token_type'    => 'Bearer',
            'expires_at'    => Carbon::parse($token->expires_at)->toDateTimeString()
        ]);
    }

    /**
     * Cierre de sesión (anular el token)
     */
    public function logout(Request $request)
    {
        $request->user()->token()->revoke();

        return response()->json([
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * Obtener el objeto User como json
     */
    public function user(Request $request)
    {
        return response()->json($request->user());
    }

    /**
     * No esta autorizado
     */
    public function notAuth(){
        return response()->json([
            'message' => 'Unauthorized'
        ], 401);
    }

}
