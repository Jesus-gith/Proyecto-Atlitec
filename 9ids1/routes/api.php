<?php

use App\Http\Controllers\CategoriaController;
use App\Http\Controllers\LoginController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('login',[LoginController::class,'login']);

Route::get('categorias',[CategoriaController::class,'listAPI']);
Route::post('categoria',[CategoriaController::class,'getAPI']);
Route::post('categoria/guardar',[CategoriaController::class,'saveAPI']);
Route::post('categoria/borrar',[CategoriaController::class,'deleteAPI']);