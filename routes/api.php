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

    Route::apiResource('publicaciones', 'PublicacionController');

});

// Aqui van las rutas de los directivos
Route::group([
    'prefix' => 'directivo',
    'namespace' => 'API\Directivo',
    'middleware' => 'auth:api'
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');
    Route::apiResource('eventos', 'EventoController');

});

Route::group([
    'prefix' => 'publico',
    'namespace' => 'API\Publico',
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');

});


//Aquí van las rutas de los Profesores

Route::group([
    'prefix' => 'profesor',
    'namespace' => 'API\Profesor',
    'middleware' => 'auth:api'
], function () {

    Route::apiResource('publicaciones', 'PublicacionController');
    Route::apiResource('eventos', 'EventoController');

});

