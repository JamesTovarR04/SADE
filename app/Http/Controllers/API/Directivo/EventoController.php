<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class EventoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'dia' => 'required|date_format:Y-m-d',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $eventos = DB::connection('directivo')
            ->table('vs_eventos')
            ->select(
                'idEventos',
                'hora',
                'descripcion',
                'idUsuario',
                'nombreCompleto',
                'tipo'
            )->where(function($query) use ($request){
                $query->where('directivos',1)
                    ->orWhere('idUsuario',$request->user()->idUsuario);
            })
            ->whereDate('hora', $request['dia'])
            ->orderBy('hora', 'asc')
            ->get();

            // SQL:... WHERE (directivos=1 OR idUsuario=x) AND DATE(hora)=$fecha

        return response()->json($eventos);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'hora'          => 'required|date_format:Y-m-d H:i:s',
            'descripcion'   => 'required|string|max:100',
            'publico'       => 'required|boolean',
            'directivo'     => 'required|boolean',
            'profesor'      => 'required|boolean',
            'estudiante'    => 'required|boolean'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $opcionesPrivacidad = [
            $request['publico'],
            $request['directivo'],
            $request['profesor'],
            $request['estudiante']
        ];

        $positivos = 0;
        foreach ($opcionesPrivacidad as $value)
            if($value == 1) $positivos++;

        if($positivos == 0)
            $idPrivacidad = 8;
        else
            $idPrivacidad = DB::connection('directivo')->select('SELECT getIdPrivacidad(?,?,?,?) AS idPrivacidad',$opcionesPrivacidad)[0]->idPrivacidad;

        $evento = [
            'hora'          => $request['hora'],
            'descripcion'   => $request['descripcion'],
            'idUsuario'     => $request->user()->idUsuario,
            'idPrivacidad'  => $idPrivacidad,
        ];

        DB::connection('directivo')
            ->table('eventos')->insert($evento);

        return response()->json(['message'=>'Evento agregado']);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return response()->json(['message'=>'Estamos trabajando en esto :/']);
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
        return response()->json(['message'=>'Estamos trabajando en esto :/']);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $idEvento
     * @return \Illuminate\Http\Response
     */
    public function destroy($idEvento)
    {
        DB::connection('directivo')
            ->table('eventos')->where('idEventos', $idEvento)->delete();
        
        return response()->json(['message' => 'Se canceló el evento']);
    }
}
