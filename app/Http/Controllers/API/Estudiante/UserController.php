<?php

namespace App\Http\Controllers\API\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Intervention\Image\ImageManagerStatic as Image;

class UserController extends Controller
{
    
    /**
     * Actualizar Datos
     * 
     * @param Request $request
     */
    public function update(Request $request){

        $validacion = Validator::make($request->all(),[
            'direccion'     => 'string|max:45',
            'email'         => 'unique:directivo.usuarios,email|email|max:45',
            'contrasena'    => 'string|min:5|max:40'
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $contrasena = NULL;
        if($request['contrasena'] != '')
            $contrasena = Hash::make($request['contrasena']);

        DB::connection('estudiante')
            ->select('CALL p_est_updateDatos(?,?,?,?)',[
                $request->user()->idUsuario,
                $request['direccion'],
                $request['email'],
                $contrasena
            ]);

        return response()->json([
            'message'   => 'Se actualizaron los datos.'
        ]);

    }

    /**
     * Ver mis datos
     * 
     * @param Request $request
     */
    public function show(Request $request){

        $datos['datos'] = DB::connection('estudiante')
            ->select('CALL p_est_verDatosEstudiante(?)',[$request->user()->idUsuario]);

        $datos['telefonos'] = DB::connection('estudiante')
            ->select('CALL p_est_verTelefonos(?)',[$request->user()->idUsuario]);

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
                DB::connection('estudiante')
                    ->select('CALL p_est_changeFotoPerfil(?,?)',[$usuario->idUsuario,$fileName]);
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
