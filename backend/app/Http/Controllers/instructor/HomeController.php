<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\StudyClass;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index(){
        $instructor_id = auth()->id();
        $numClasses = StudyClass::where('instructor_id', $instructor_id)->count();
    }
}
