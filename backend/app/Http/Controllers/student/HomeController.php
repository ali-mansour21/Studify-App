<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\StudentNote;
use App\Models\StudyClass;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index(){
        $user = auth()->user();
        $categories = $user->categories;
        $student_notes = StudentNote::whereHas('categories', function ($query) use ($categories) {
            $query->whereIn('id', $categories->pluck('id'));
        })->get();
        $classes = StudyClass::whereHas('categories', function ($query) use ($categories) {
            $query->whereIn('id', $categories->pluck('id'));
        })->get();
    }
}
