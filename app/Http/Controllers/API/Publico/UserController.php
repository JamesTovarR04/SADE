<?php

namespace App\Http\Controllers\API\Publico;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
    /**
     * Cargar Foto de perfil
     * 
     * @param Request $request
     */
    public function descargarFoto($nameFoto){

        $nombreUsuario = DB::connection('profesor')
            ->table('vs_infousuario')
            ->where('fotoPerfil',$nameFoto)
            ->value('nombreCompleto');

        $nombreImagen = str_replace(' ','',$nombreUsuario) . '.jpg';

        return Storage::download('images/fotos/'.$nameFoto.'.jpg', $nombreImagen);

    }
}
