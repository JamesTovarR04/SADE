<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class TelefonoController extends Controller
{
    
    /**
     * Agregar telefono a usuario
     * 
     * @param int idUsuario
     * @return response confirmacion
     */
    public function store(Request $request,$idUsuario){

        $request['idUsuario'] = $idUsuario;

        $validacion = Validator::make($request->all(),[
            'telefono'    => 'required|string|max:15',
            'idUsuario'   => 'required|integer|exists:directivo.usuarios,idUsuario'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $idTelefono = DB::connection('directivo')
            ->table('telefono')
            ->where('idUsuario',$idUsuario)
            ->insert([
                'idUsuario' => $idUsuario,
                'telefono'  => $request['telefono']
            ]);

        if(!is_null($idTelefono))
            return response()->json([
                'message'   => 'Se agregó el teléfono.',
                'id'        => $idTelefono,
            ],201);
        else
            return response()->json([
                'message'   => 'No se agregó el teléfono.'
            ]);

    }

    /**
     * Borrar telefono
     * 
     * @param int   $idTelefono
     */
    public function destroy($idTelefono){

        $afectado = DB::connection('directivo')
            ->table('Telefono')->where('idTelefono', $idTelefono)->delete();
        
        if($afectado > 0)
            return response()->json([
                'message'   => 'El telefono fue eliminado.'
            ]);
        else
            return response()->json([
                'message'   => 'No existe este teléfono.'
            ],404);

    }


}
