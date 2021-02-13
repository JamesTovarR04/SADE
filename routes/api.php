<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group([
    'prefix' => 'auth',
], function () {
    Route::post('login', 'AuthController@login');
    Route::get('notAuth', 'AuthController@notAuth')->name('notLogin');

    Route::group([
        'middleware' => 'auth:api'
    ], function () {
        Route::get('logout', 'AuthController@logout');
        Route::get('user', 'AuthController@user');
    });
});

Route::group([
    'prefix' => 'publico',
    'namespace' => 'API\Publico',
], function () {
    Route::get('publicaciones', 'PublicacionController@index');
    Route::get('eventos', 'EventoController@index');
    Route::get('eventos/mes', 'EventoController@enMes');
    Route::group([
        'prefix' => 'info',
    ], function () {
        Route::get('directivos', 'InfoSchoolController@directivos');
        Route::get('usuarios', 'InfoSchoolController@numeroUsuarios');
    });
});

// Aqui van las rutas de los directivos
Route::group([
    'prefix' => 'directivo',
    'namespace' => 'API\Directivo',
    'middleware' => ['auth:api','role:directivo']
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');
    Route::apiResource('eventos', 'EventoController');
    Route::get('eventosmes', 'EventoController@enMes');
    Route::apiResource('estudiantes', 'EstudianteController');
    Route::apiResource('profesores', 'ProfesorController');
    Route::apiResource('directivos', 'DirectivoController');
    Route::apiResource('grupos', 'GradoController');
    Route::post('telefonos/{idUsuario}','TelefonoController@store');
    Route::delete('telefonos/{idTelefono}','TelefonoController@destroy');
    Route::get('notificaciones', 'NotificacionController@index');
    Route::get('notificaciones/{id}', 'NotificacionController@visto');
    Route::get('numero/notificaciones', 'NotificacionController@numero');

});

//Aquí van las rutas de los Profesores
Route::group([
    'prefix' => 'profesor',
    'namespace' => 'API\Profesor',
    'middleware' => ['auth:api','role:profesor']
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');
    Route::apiResource('eventos', 'EventoController');
    Route::get('eventosmes', 'EventoController@enMes');
    Route::get('notificaciones', 'NotificacionController@index');
    Route::get('notificaciones/{id}', 'NotificacionController@visto');
    Route::get('numero/notificaciones', 'NotificacionController@numero');
    Route::get('grupos', 'GrupoController@index');
    Route::get('grupos/{id}', 'GrupoController@show');
    Route::post('telefono', 'TelefonoController@store');
    Route::delete('telefono/{id}', 'TelefonoController@destroy');
    Route::put('usuario', 'UserController@update');
    Route::get('usuario', 'UserController@show');

});

//Aquí van las rutas de los Estudiantes
Route::group([
    'prefix' => 'estudiante',
    'namespace' => 'API\Estudiante',
    'middleware' => ['auth:api','role:estudiante']
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');
    Route::get('eventos', 'EventoController@index');
    Route::get('eventos/mes', 'EventoController@enMes');
    Route::get('notificaciones', 'NotificacionController@index');
    Route::get('notificaciones/{id}', 'NotificacionController@visto');
    Route::get('numero/notificaciones', 'NotificacionController@numero');
    Route::get('grupos', 'GrupoController@index');
    Route::get('grupos/{id}', 'GrupoController@show');
    Route::get('migrupo', 'GrupoController@miGrupo');
    Route::put('usuario', 'UserController@update');
    Route::get('usuario', 'UserController@show');
    Route::post('telefono', 'TelefonoController@store');
    Route::delete('telefono/{id}', 'TelefonoController@destroy');
    
});
