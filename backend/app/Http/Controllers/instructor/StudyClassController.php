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
        $studyClasses = $this->getClassesWithStudentCounts($studyClasses);
        return response()->json(['status' => 'success', 'data' => $studyClasses]);
    }
    public function store(Request $request)
    {
        $instructor = auth()->user();
        $data = $request->validate([
            'class_name' => ['required', 'string', 'min:3', 'max:255'],
            'class_image' => ['required', 'file']
        ]);
        $instructor->instructorClasses()->create($data);
        return response()->json(['status' => 'success', 'message' => 'Class Created Successfully']);
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
