<?php

namespace App\Http\Controllers\API\Publico;

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
        $validacion = Validator::make($request->all(),[
            'buscar' => 'string|min:4|max:100',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if($request['buscar']=='')
            $publicaciones = DB::connection('publico')
                ->table('vs_pub_publicaciones')
                ->get();
        else
            $publicaciones = DB::connection('publico')
                ->select('CALL p_pub_buscarPublicacion(?)',[$request['buscar']]);
        
        return response()->json($publicaciones);
    }

}
