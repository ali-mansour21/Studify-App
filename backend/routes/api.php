<?php

use App\Http\Controllers\common\ClassRequestController;
use App\Http\Controllers\instructor\AIResourceController;
use App\Http\Controllers\instructor\AuthController as InstructorAuthController;
use App\Http\Controllers\instructor\HomeController as InstructorHomeController;
use App\Http\Controllers\instructor\MaterialController;
use App\Http\Controllers\instructor\StudyClassController;
use App\Http\Controllers\student\AssignmentSubmissionController;
use App\Http\Controllers\student\AuthController;
use App\Http\Controllers\student\CategoryController;
use App\Http\Controllers\student\HomeController;
use App\Http\Controllers\student\StudentFAQControlller;
use App\Http\Controllers\student\StudentResources;
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
        Route::get('resources', [HomeController::class, 'index'])->name('resources.index');
        Route::post('resources', [HomeController::class, 'store']);
        Route::post('dataSearch', [HomeController::class, 'searchData'])->name('resources.search');
        Route::get('notifications', [HomeController::class, 'getNotifications']);
        Route::get('studentClasses', [StudentResources::class, 'studentEnrolledClasses'])->name('student.enrolled.classes');
        Route::get('studentNotes', [StudentResources::class, 'studentCreatedNotes'])->name('student.created.notes');
        Route::post('join_class', [ClassRequestController::class, 'enrollWithCode']);
        Route::post('request_join_class', [ClassRequestController::class, 'requestJoin']);
        Route::post('submit_assignment', [AssignmentSubmissionController::class, 'submitSolution']);
        Route::post('student_faq', [StudentFAQControlller::class, 'askQuestion']);
        Route::post('student_logout', [AuthController::class, 'logout']);
    });
    Route::middleware('instructor')->group(function () {
        Route::get('home/state', [InstructorHomeController::class, 'index']);
        Route::get('home/data', [InstructorHomeController::class, 'chartData']);
        Route::get('home/notifications', [InstructorHomeController::class, 'getNotifications']);
        Route::get('classes', [StudyClassController::class, 'index']);
        Route::post('classes', [StudyClassController::class, 'store']);
        Route::post('classes/material', [MaterialController::class, 'store'])->name('materials.store');
        Route::post('classes/material/addUnit', [MaterialController::class, 'storeData']);
        Route::post('class/request', [ClassRequestController::class, 'approveRequest']);
        Route::post('classes/invite', [ClassRequestController::class, 'inviteStudent']);
        Route::post('instructor_logout', [InstructorAuthController::class, 'logout']);
        Route::post('faq_file', [AIResourceController::class, 'submitFaqFile'])->name('submitFaqFile');
        Route::post('correction_file', [AIResourceController::class, 'submitCorrectionFile'])->name('submitCorrectionFile');
    });
});
Route::middleware('guest')->group(function () {
    Route::get('categories', [CategoryController::class, 'index']);
    Route::post('student_register', [AuthController::class, 'register']);
    Route::post('student_login', [AuthController::class, 'login']);
    Route::post('instructor_register', [InstructorAuthController::class, 'register']);
    Route::post('instructor_login', [InstructorAuthController::class, 'login']);
});
Route::post('/sendText', [CategoryController::class, 'storeImage']);
Route::get('/get', [CategoryController::class, 'get']);
