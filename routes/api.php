<?php

use App\Http\Controllers\API\Directivo\DirectivoController;
use App\Http\Controllers\API\Directivo\EstudianteController;
use App\Http\Controllers\API\Directivo\EventoController as DirectivoEventoController;
use App\Http\Controllers\API\Directivo\GradoController;
use App\Http\Controllers\API\Directivo\NotificacionController;
use App\Http\Controllers\API\Directivo\ProfesorController;
use App\Http\Controllers\API\Directivo\PublicacionController as DirectivoPublicacionController;
use App\Http\Controllers\API\Directivo\TelefonoController;
use App\Http\Controllers\API\Directivo\UserController as DirectivoUserController;
use App\Http\Controllers\API\Profesor\EstudiantesController;
use App\Http\Controllers\API\Profesor\EventoController as ProfesorEventoController;
use App\Http\Controllers\API\Profesor\GrupoController;
use App\Http\Controllers\API\Profesor\NotificacionController as ProfesorNotificacionController;
use App\Http\Controllers\API\Profesor\PublicacionController as ProfesorPublicacionController;
use App\Http\Controllers\API\Profesor\TelefonoController as ProfesorTelefonoController;
use App\Http\Controllers\API\Profesor\UserController as ProfesorUserController;
use App\Http\Controllers\API\Publico\EventoController;
use App\Http\Controllers\API\Publico\InfoSchoolController;
use App\Http\Controllers\API\Publico\PublicacionController;
use App\Http\Controllers\API\Publico\UserController;
use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
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

// Rutas de autenticacion
Route::group([
    'prefix' => 'auth',
], function () {
    Route::post('login',[AuthController::class, 'login']);
    Route::group([
        'middleware' => 'auth:sanctum'
    ], function () {
        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('user', [AuthController::class, 'getUser']);
        Route::get('tokens', [AuthController::class, 'getTokens']);
        Route::delete('tokens', [AuthController::class, 'deleteTokens']);
    });
});

// Rutas publicas
Route::group([
    'prefix' => 'publico',
    'namespace' => 'API\Publico',
],
    function () {
        Route::get('publicaciones', [PublicacionController::class,'index']);
        Route::get('eventos', [EventoController::class, 'index']);
        Route::get('eventos/mes', [EventoController::class, 'enMes']);
        Route::get('usuario/foto/{id}', [UserController::class, 'descargarFoto']);
        Route::group([
            'prefix' => 'info',
        ], function () {
            Route::get('directivos', [InfoSchoolController::class, 'directivos']);
            Route::get('usuarios', [InfoSchoolController::class, 'numeroUsuarios']);
        });
    }
);

// Aqui van las rutas de los directivos
Route::group([
    'prefix' => 'directivo',
    'middleware' => ['auth:sanctum', 'role:directivo']
], function () {

    Route::apiResource('publicaciones', DirectivoPublicacionController::class);
    Route::get('publicaciones/{id}/like', [DirectivoPublicacionController::class,'like']);
    Route::get('publicaciones/{id}/dislike', [DirectivoPublicacionController::class, 'dislike']);
    Route::get('mispublicaciones', [DirectivoPublicacionController::class, 'delUsuario']);
    Route::get('privacidad/publicacion/{id}', [DirectivoPublicacionController::class, 'privacidad']);

    Route::apiResource('eventos', DirectivoEventoController::class);
    Route::get('eventosmes', [DirectivoEventoController::class,'enMes']);

    Route::apiResource('estudiantes', EstudianteController::class);
    Route::apiResource('profesores', ProfesorController::class);
    Route::apiResource('directivos', DirectivoController::class);
    Route::post('usuario/foto/{id}', [DirectivoUserController::class, 'cargarFoto']);

    Route::apiResource('grupos', GradoController::class);
    Route::post('grupos/{id}/profesor', [GradoController::class, 'addProfesor']);

    Route::post('telefonos/{idUsuario}', [TelefonoController::class, 'store']);
    Route::delete('telefonos/{idTelefono}', [TelefonoController::class, 'destroy']);

    Route::get('notificaciones', [NotificacionController::class, 'index']);
    Route::get('notificaciones/{id}', [NotificacionController::class, 'visto']);
    Route::get('numero/notificaciones', [NotificacionController::class, 'numero']);

});

//Aquí van las rutas de los Profesores
Route::group([
    'prefix' => 'profesor',
    'middleware' => ['auth:sanctum', 'role:profesor']
], function () {

    Route::apiResource('publicaciones', ProfesorPublicacionController::class);
    Route::get('publicaciones/{id}/like', [ProfesorPublicacionController::class, 'like']);
    Route::get('publicaciones/{id}/dislike', [ProfesorPublicacionController::class, 'dislike']);
    Route::get('mispublicaciones', [ProfesorPublicacionController::class, 'delUsuario']);
    Route::get('privacidad/publicacion/{id}', [ProfesorPublicacionController::class, 'privacidad']);

    Route::apiResource('eventos', ProfesorEventoController::class);
    Route::get('eventosmes', [ProfesorEventoController::class, 'enMes']);

    Route::get('notificaciones', [ProfesorNotificacionController::class, 'index']);
    Route::get('notificaciones/{id}', [ProfesorNotificacionController::class, 'visto']);
    Route::get('numero/notificaciones', [ProfesorNotificacionController::class, 'numero']);

    Route::get('grupos', [GrupoController::class, 'index']);
    Route::get('grupos/{id}', [GrupoController::class, 'show']);

    Route::get('estudiantes/director/{idGrupo}', [EstudiantesController::class, 'listadoGrupoDirectivo']);
    Route::get('estudiantes/misgrupos/{idGrupo}', [EstudiantesController::class, 'listadoGrupo']);

    Route::post('telefono', [ProfesorTelefonoController::class, 'store']);
    Route::delete('telefono/{id}', [ProfesorTelefonoController::class, 'destroy']);

    Route::put('usuario', [ProfesorUserController::class, 'update']);
    Route::get('usuario', [ProfesorUserController::class, 'show']);
    Route::post('usuario/foto', [ProfesorUserController::class, 'cargarFoto']);

});