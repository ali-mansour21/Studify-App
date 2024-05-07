<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class StudyClassController extends Controller
{
    public function index()
    {
        $instructor = auth()->user();
        $studyClasses = $instructor->instructorClasses()->with('students')->get();
    }
    private function getClassesWithStudentCounts($studyClasses)
    {
        $classesWithCounts = $studyClasses->map(function ($class) {
            return  [
                'class' => $class,
                'student_count' => $class->students->count()
            ];
        });

        return $classesWithCounts;
    }
}
