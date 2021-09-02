<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{

    /**
     * Permite la autenticación
     * 
     * @return Response
     */
    public function login(Request $request)
    {

        $validacion = Validator::make($request->all(), [
            'user' => 'required|string',
            'password' => 'required|string',
            'remember_me' => 'boolean',
            'create_token' => 'boolean'
        ]);

        if ($validacion->fails())
            return response(['errors' => $validacion->errors()->all()], 422);

        /**
         * Llamar a procedimiento para buscar idUusario por email o numero de documento
         */
        $dataLogin = DB::select('CALL p_pub_login(?)', [$request['user']]);

        if (count($dataLogin) == 0) {
            return response()
                ->json([
                    'code' => 2,
                    'Message' => 'Usuario o contraseña incorrectos.'
                ], 401);
        }

        if ($dataLogin[0]->intentosConexion == 8) {
            return response()
                ->json([
                    'code' => 3,
                    'Message' => 'El usuario fue bloqueado por realizar demasiados intentos sin exito.'
                ], 401);
        }

        $credentials = ['idUsuario' => $dataLogin[0]->idUsuario, 'password' => $request['password']];

        if (!Auth::attempt($credentials))
            return response()->json([
                'code' => 2,
                'Message' => 'Usuario o contraseña incorrectos.'
            ], 401);

        // Reiniciar conteo de intentos
        DB::table('Usuarios')
        ->where('idUsuario', $dataLogin[0]->idUsuario)
            ->update([
                'intentosConexion' => 0
            ]);

        $user = $request->user();

        $response = [
            'rol'           => $user->rol(),
            'usuario'       => $user->nombres,
        ];

        if($request['create_token'])
            $response['token'] = $request->user()->createToken('sade-token')->plainTextToken;

        return response()->json($response);

    }

    /**
     * Cierre de sesión
     * 
     * @return Response
     */
    public function logout(Request $request)
    {

        if((array)$request->user()->currentAccessToken())
            $request->user()->currentAccessToken()->delete();
        else {
            $request->session()->invalidate();
            $request->session()->regenerateToken();
        }

        return response()->json([
            'message' => 'Se cerró la sesión correctamente.'
        ]);
    }

}
