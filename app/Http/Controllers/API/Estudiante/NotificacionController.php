<?php

namespace App\Http\Controllers\API\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class NotificacionController extends Controller
{
    
    public function index(Request $request)
    {
        $notificaciones = DB::connection('estudiante')
        ->select('CALL p_notificacionesUsuario(?)',[ $request->user()->idUsuario]);

        return response()->json($notificaciones);

    }
    
    public function visto(Request $request, $idNotificacion)
    {
        $visto = DB::connection('estudiante')
        ->select('CALL p_est_vistoNotificacion(?,?)',[$idNotificacion, $request->user()->idUsuario]);

        return response()->json(['message'=> 'Se vio la notificación']);
    }

} 
