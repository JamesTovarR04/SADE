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
         * Llamar a procedimiento para buscar idUsuario por email o numero de documento
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

        $response['user'] = $this->dataUser($request);

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
        if((array)$request->user()->currentAccessToken()) {
            $request->user()->currentAccessToken()->delete();
            return response()->json([
                'message' => 'Se cerró la sesión correctamente.'
            ]);
        }

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('login');
    }

    /**
     * Tokens de autenticacion
     * 
     * @return Response
     */
    public function getTokens(Request $request)
    {
        return response()->json($request->user()->tokens);
    }

    /**
     * Borrar tokens de autenticacion
     * 
     * @return Response
     */
    public function deleteTokens(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Se borraron todos los tokens.'
        ]);
    }

    /**
     * Cierre de sesión
     * 
     * @return Response
     */
    public function getUser(Request $request)
    {
        $usuario = $this->dataUser($request);
        return response()->json($usuario);
    }

    /**
     * Información de usuario
     * 
     * @return array
     */
    private function dataUser(Request $request)
    {
        $usuario = $request->user();

        switch ($usuario->tipo) {
            case 1:
                $usuario->grado = DB::connection('estudiante')
                ->table('vs_est_infoestudiantes')
                ->where('idUsuario', $usuario->idUsuario)
                    ->value('idGrupo');
                break;
            case 2:
                $usuario->grupo = DB::connection('profesor')
                ->table('grupos')
                    ->where('director', $usuario->idUsuario)
                    ->value('idGrupo');
                $usuario->misGrupos = DB::connection('profesor')
                ->select('call p_prf_misGruposClases(?)', [$usuario->idUsuario]);
                break;
        }

        return $usuario;
    }

}
