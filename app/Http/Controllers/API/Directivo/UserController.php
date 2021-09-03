<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Intervention\Image\ImageManagerStatic as Image;

class UserController extends Controller
{
    
    /**
     * Cargar Foto de perfil
     * 
     * @param Request $request
     */
    public function cargarFoto(Request $request, $idUsuario){

        $validacion = Validator::make($request->all(),[
            'foto' => 'required|mimes:jpeg,jpg,png',     
        ]);

        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        if ($request->hasFile('foto')) {
            $fotoPerfil = DB::connection('directivo')
                ->table('usuarios')
                ->where('idUsuario',$idUsuario)
                ->value('fotoPerfil');

            $image = $request->file('foto');

            if(is_null($fotoPerfil)){
                $fileName = uniqid().$idUsuario;
                DB::connection('directivo')
                    ->table('usuarios')
                    ->where('idUsuario',$idUsuario)
                    ->update([
                        'fotoPerfil' => $fileName
                    ]);
            }else{
                $fileName = $fotoPerfil;
                Storage::delete('images/fotos/'.$fileName.'.jpg');
            }

            $img = Image::make($image->getRealPath());

            $altoImg = $img->height();
            $anchoImg = $img->width();

            // Recortar imagen a 1:1
            if($altoImg != $anchoImg){
                $cropWith = $anchoImg;
                $cropHeight = $altoImg;
                $cropX = 0;
                $cropY = 0;
                if($altoImg > $anchoImg){
                    $cropY = round(($altoImg - $anchoImg) / 2);
                    $cropHeight = $cropWith;
                }else{
                    $cropX = round(($anchoImg - $altoImg) / 2);
                    $cropWith = $cropHeight;
                }
                $img->crop($cropWith, $cropHeight, $cropX, $cropY);
            }

            // Cambiar tamaño y formato
            $img->resize(180, 180, function ($constraint) {
                $constraint->aspectRatio();                 
            })->encode('jpg', 75);

            $img->stream();
            Storage::disk('local')->put('images/fotos/'.$fileName.'.jpg', $img, 'public');

            return Storage::download('images/fotos/'.$fileName.'.jpg');
        }

        return response()->json([
            'message' => 'error al cambiar la imagen.'
        ],422);

    }

}
