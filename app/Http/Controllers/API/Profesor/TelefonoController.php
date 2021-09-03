<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class TelefonoController extends Controller
{
    public function store(Request $request){

        $validacion = Validator::make($request->all(),[
            'telefono' => 'required|string|max:15',          
        ]);
        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }
        
        DB::connection('profesor')
            ->select('CALL p_prf_addTelefono(?,?)', [$request->user()->idUsuario, $request['telefono']]);
        return response()->json(['message'=>'Telefono agregado'],201);

    }


    public function destroy(Request $request, $idTelefono){

        DB::connection('profesor')
            ->select('CALL p_prf_deleteTelefono(?,?)',[$idTelefono,$request->user()->idUsuario]);
        return response()->json(['message'=> 'Se borró el teléfono']);
    }

}
