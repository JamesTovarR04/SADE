<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class NotificacionController extends Controller
{
    public function index(Request $request)
    {
        $notificaciones = DB::connection('profesor')
        ->select('CALL p_notificacionesUsuario(?)',[ $request->user()->idUsuario]);

        return response()->json($notificaciones);

    }
    
    public function visto(Request $request, $idNotificacion)
    {
        $visto = DB::connection('profesor')
        ->select('CALL p_prf_vistoNotificacion(?,?)',[$idNotificacion, $request->user()->idUsuario]);

        return response()->json(['message'=> 'Se vio la notificación']);
    }

    public function numero(Request $request){

        $numero = DB::connection('profesor')
            ->select('CALL p_numNotificaciones(?)',[$request->user()->idUsuario]);
        return response()->json($numero[0]);

    }

}
