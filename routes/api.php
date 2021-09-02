<?php

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

