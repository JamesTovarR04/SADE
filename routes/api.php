<?php

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

/*Route::get('/usuarios', 'UsuariosController@obtener');
Route::put('/usuarios', 'UsuariosController@insertar');
Route::patch('/usuarios/{idUsuario}', 'UsuariosController@actualizar');
Route::delete('/usuarios/{idUsuario}', 'UsuariosController@borrar');
*/
Route::group([
    'prefix' => 'publico',
    'namespace' => 'API\Publico',
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');

});

Route::group([
    'prefix' => 'directivo',
    'namespace' => 'API\Directivo',
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');

});

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
