<?php

namespace App\Http\Controllers\API\Directivo;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ProfesorController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $validacion = Validator::make($request->all(),[
            'buscar' => 'string|min:3|max:100',
            'colorden'  => Rule::in(['','nombre','documentoIdentidad','perfilAcademico']),
            'orden'     => Rule::in(['asc','desc'])
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if($request['buscar'] == ''){
            $columna = ($request['colorden'] == '') ? 'idUsuario' : $request['colorden'];
            $orden = ($request['orden'] == '') ? 'asc' : $request['orden'];
            $profesor = DB::connection('directivo')
                ->table('vs_infodocentes')
                ->orderBy($columna, $orden)
                ->paginate(15);
        }else
            $profesor = DB::connection('directivo')
                ->select('CALL p_dir_buscarDocente(?)',[$request['buscar']]);
        
        return response()->json($profesor);
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
            'nombres'   => 'required|string|min:3|max:60',
            'apellido1' => 'required|string|min:3|max:45',
            'apellido2' => 'string|min:3|max:45',
            'email'     => 'required|unique:directivo.usuarios,email|email|max:45',
            'contrasena'=> 'string|min:5|max:25',
            'sexo'      => ['required', Rule::in(['M','F'])],
            'fechaNacimiento' => 'required|date_format:Y-m-d',
            'direccion'         => 'string|min:4|max:45',
            'perfil'            => 'string|min:4|max:255',
            'tipoDocumento'     => ['required_with:numeroDocumento', Rule::in(['CC','CE','RC','TI','NS'])],
            'numeroDocumento'   => 'required_with:tipoDocumento|integer',
            'fechaExpedicion'   => 'required_with:numeroDocumento|date_format:Y-m-d',
            'lugarExpedicion'   => 'required_with:fechaExpedicion|string|max:45',
            'telefonos'         => 'Array',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        if($request['contrasena'] == '')
            $contrasena = $request['numeroDocumento'];
        else
            $contrasena = $request['contrasena'];

        // Iniciar transaccion
        DB::connection('directivo')->beginTransaction();

        // Crea el usuario
        $idUsuario = DB::connection('directivo')
                ->table('usuarios')
                ->insertGetId([
                    'nombres'       => $request['nombres'],
                    'apellido1'     => $request['apellido1'],
                    'apellido2'     => $request['apellido2'],
                    'tipo'          => 2,
                    'email'         => $request['email'],
                    'sexo'          => $request['sexo'],
                    'intentosConexion'=> 0,
                    'fechaNacimiento' => $request['fechaNacimiento'],
                    'contrasenia'     => Hash::make($contrasena),
                ]);
 
        // Crea el profesor
        DB::connection('directivo')
                ->table('docentes')
                ->insert([
                    'idUsuario'       => $idUsuario,
                    'direccion'       => $request['direccion'],
                    'perfilAcademico' => $request['perfil']
                ]);

        // Crear documento
        if($request['tipoDocumento'] != '')
            DB::connection('directivo')
                    ->table('documentoidentidad')
                    ->insert([
                        'idUsuario'         => $idUsuario,
                        'tipodocumento'     => $request['tipoDocumento'],
                        'numero'            => $request['numeroDocumento'],
                        'fechaExpedicion'   => $request['fechaExpedicion'],
                        'lugarExpedicion'   => $request['lugarExpedicion']
                    ]); 

        // Insertar telefonos
        if(!is_null($request['telefonos'])){
            $telefonos = [];
            foreach ($request['telefono'] as $value) {
                array_push($telefonos,[
                    'idUsuario'  => $idUsuario,
                    'telefono'   => $value
                ]);
            }
            DB::connection('directivo')->table('telefono')->insert($telefonos);
        }

        // Finalizar Transaccion
        DB::connection('directivo')->commit();

        return response()->json([
            'message'   => 'El profesor '.$request['nombres'].' fue registrado con exito',
            'id'        => $idUsuario,
        ]);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($idProfesor)
    {
        $docente['data'] = DB::connection('directivo')
            ->table('vs_datosdocentes')
            ->where('idUsuario',$idProfesor)
            ->first();
        if(is_null( $docente['data'])){
            return response()->json([
                'message'   => 'El profesor no existe'
            ],404);
        }
        $docente['telefonos'] = DB::connection('directivo')
            ->table('telefono')
            ->select('idTelefono','telefono')
            ->where('idUsuario',$idProfesor)
            ->get();

        return response()->json($docente);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idUsuario)
    {
        $validacion = Validator::make($request->all(),[
            'nombres'   => 'string|min:3|max:60',
            'apellido1' => 'string|min:3|max:45',
            'apellido2' => 'string|min:3|max:45',
            'email'     => 'unique:directivo.usuarios,email|email|max:45',
            'contrasena'=> 'string|min:5|max:25',
            'sexo'      => [Rule::in(['M','F'])],
            'fechaNacimiento' => 'date_format:Y-m-d',
            'direccion' => 'string|min:4|max:45',
            'perfil'            => 'string|min:4|max:255',
            'tipoDocumento'     => [Rule::in(['CC','CE','RC','TI','NS'])],
            'numeroDocumento'   => 'integer',
            'fechaExpedicion'   => 'date_format:Y-m-d',
            'fechaExpedicion'   => 'string|max:45',
        ]);

        if($validacion->fails()){
            return response(['errors' => $validacion->errors()->all()], 422);
        }

        $actualizar1['nombres']         = $request['nombres'];
        $actualizar1['apellido1']       = $request['apellido1'];
        $actualizar1['apellido2']       = $request['apellido2'];
        $actualizar1['email']           = $request['email'];
        $actualizar1['contrasenia']     = (is_null($request['contrasena'])) ? $request['contrasena'] : Hash::make($request['contrasena']);
        $actualizar1['sexo']            = $request['sexo'];
        $actualizar1['fechaNacimiento'] = $request['fechaNacimiento'];

        $actualizar2['tipoDocumento']   = $request['tipoDocumento'];
        $actualizar2['numero']          = $request['numeroDocumento'];
        $actualizar2['fechaExpedicion'] = $request['fechaExpedicion'];
        $actualizar2['lugarExpedicion'] = $request['lugarExpedicion'];

        $actualizar3['direccion']           = $request['direccion'];
        $actualizar3['perfilAcademico']     = $request['perfil'];

        foreach ($actualizar1 as $key => $value) {
            if(is_null($value))
                unset($actualizar1[$key]);
        }

        foreach ($actualizar2 as $key => $value) {
            if(is_null($value))
                unset($actualizar2[$key]);
        }

        foreach ($actualizar3 as $key => $value) {
            if(is_null($value))
                unset($actualizar3[$key]);
        }

        $cambiado = 0;

        if(count($actualizar1) > 0)
            $cambiado += DB::connection('directivo')
                ->table('Usuarios')
                ->where('idUsuario',$idUsuario)
                ->update($actualizar1);

        if(count($actualizar2) > 0)
            $cambiado += DB::connection('directivo')
                ->table('DocumentoIdentidad')
                ->where('idUsuario',$idUsuario)
                ->update($actualizar2);

        if(count($actualizar3) > 0)
            $cambiado += DB::connection('directivo')
                ->table('Docentes')
                ->where('idUsuario',$idUsuario)
                ->update($actualizar3);

        if($cambiado > 0)
            return response()->json([
                'message'   => 'Los datos del profesor han sido actualizado.'
            ]);
        else
            return response()->json([
                'message'   => 'No se ha actualizado ningun dato.'
            ]);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($idProfesor)
    {
        $afectado = DB::connection('directivo')
            ->table('usuarios')
            ->where('idUsuario',$idProfesor)
            ->where('tipo',2)
            ->update([
                'delete' => date("Y-m-d H:i:s")
            ]);

        if($afectado > 0)
            return response()->json([
                'message'   => 'El profesor fue eliminado'
            ]);
        else
            return response()->json([
                'message'   => 'No existe este profesor.'
            ]);
    }
}
