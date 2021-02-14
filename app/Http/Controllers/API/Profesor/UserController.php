<?php

namespace App\Http\Controllers\API\Profesor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\ImageManagerStatic as Image;

class UserController extends Controller
{
    //Actualizar datos

    public function update(Request $request){


        $validacion = Validator::make($request->all(),[
            'direccion' =>        'string|max:45',
            'perfil' =>           'string|max:254',
            'email' =>            'unique:directivo.usuarios,email|email|max:45',
            'contrasena' =>       'string|max:40'       
        ]);

        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        //Validación de contraseña encriptada
        $contrasena = NULL;
        if($request['contrasena'] != '')
            $contrasena = Hash::make($request['contrasena']);

        DB::connection('profesor')
            ->select('CALL p_prf_updateDatos(?,?,?,?,?)',[
            $request->user()->idUsuario,
            $request['direccion'],
            $request['perfil'],
            $request['email'],
            $contrasena
        ]);

        return response()->json(['message'=>'Se actualizaron los datos']);

    }


    public function show(Request $request){

        $datos['datos'] = DB::connection('profesor')
            ->select('CALL p_prf_verDatosDocente(?)', [$request->user()->idUsuario]);

        $datos['telefonos'] = DB::connection('profesor')
            ->select('CALL p_prf_verTelefonos(?)',[$request->user()->idUsuario]);

        return response()->json($datos);
    }

    /**
     * Cargar Foto de perfil
     * 
     * @param Request $request
     */
    public function cargarFoto(Request $request){

        $validacion = Validator::make($request->all(),[
            'foto' => 'required|mimes:jpeg,jpg,png',     
        ]);

        if($validacion->fails()){
            return response(['errors'=>$validacion->errors()->all()], 422);
        }

        if ($request->hasFile('foto')) {
            $usuario = $request->user();

            $image = $request->file('foto');

            if(is_null($usuario->fotoPerfil)){
                $fileName = uniqid().$usuario->idUsuario;
                $usuario->fotoPerfil = $fileName;
                DB::connection('profesor')
                    ->select('CALL p_prf_changeFotoPerfil(?,?)',[$usuario->idUsuario,$fileName]);
            }else{
                $fileName = $usuario->fotoPerfil;
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
