<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Las rutas estan siendo manejadas por ReactRouter
Route::get('/{path?}/{path2?}/{path3?}/{path4?}/{path5?}/{path6?}', function ($path = null) {
    switch ($path) {
        case 'directivo':
            return view('directivo');
        case 'profesor':
            return view('profesor');
        case 'estudiante':
            return view('estudiante');
        default:
            return view('publico');
    }
})->name('index');