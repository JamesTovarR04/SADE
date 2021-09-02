<?php

namespace App\Http\Controllers\API\Publico;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class InfoSchoolController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function directivos(Request $request)
    {
        $validacion = Validator::make($request->all(), [
            'buscar' => 'string|min:4|max:150',
        ]);

        if ($validacion->fails()) {
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if ($request['buscar'] == '')
            $directivos = DB::connection('publico')
                ->table('vs_pub_directivos')
                ->get();
        else
            $directivos = DB::connection('publico')
                ->select('CALL p_pub_buscarDirectivo(?)', [$request['buscar']]);

        return response()->json($directivos);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function numeroUsuarios()
    {
        $reporte = DB::connection('publico')
            ->select('CALL p_pub_numUsuarios()');

        return response()->json($reporte[0]);
    }
}
