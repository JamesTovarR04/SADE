<?php

use App\Http\Controllers\AuthController;
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

Route::get('/{any?}/{any2?}', function () {
    return view('publico');
})->name('login')
->where(['any' => '^$|[a-z0-9]+\b(?<!directivo|estudiante|profesor|auth)', 'any2' => '.*']);

// Private Routes
Route::group(['middleware' => 'auth:sanctum'], function () {
    Route::get('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/directivo/{any?}', function () {
        return view('directivo');
    })->middleware('role:directivo')->where('any', '.*')->name('directivo');
    Route::get('/estudiante/{any?}', function () {
        return view('estudiante');
    })->middleware('role:estudiante')->where('any', '.*')->name('estudiante');
    Route::get('/profesor/{any?}', function () {
        return view('profesor');
    })->middleware('role:profesor')->where('any', '.*')->name('profesor');
});