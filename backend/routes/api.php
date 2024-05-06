<?php

use App\Http\Controllers\common\ClassRequestController;
use App\Http\Controllers\student\AssignmentSubmissionController;
use App\Http\Controllers\student\AuthController;
use App\Http\Controllers\student\CategoryController;
use App\Http\Controllers\student\HomeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('jwt.auth')->group(function () {
    Route::middleware('student')->group(function () {
        Route::post('categories/select', [CategoryController::class, 'storeSelectedCategory']);
        Route::get('resources', [HomeController::class, 'index']);
        Route::post('resources', [HomeController::class, 'store']);
        Route::post('join_class', [ClassRequestController::class, 'enrollWithCode']);
        Route::post('request_join_class', [ClassRequestController::class, 'requestJoin']);
        Route::post('submit_assignment', [AssignmentSubmissionController::class, 'submitSolution']);
    });
});
Route::middleware('guest')->group(function () {
    Route::post('student_register', [AuthController::class, 'register']);
    Route::post('student_login', [AuthController::class, 'login']);
});
