<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\StudyClass;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class StudyClassController extends Controller
{
    public function index()
    {
        $instructor = auth()->user();
        $classes = $instructor->instructorClasses()->with(['materials.topics', 'materials.assignments'])
            ->get();
        $studyClasses = $instructor->instructorClasses()->with('students')->get();
        $studentCount = $this->getClassesWithStudentCounts($studyClasses);
        return response()->json(['status' => 'success', 'data' => [
            'studentCount' => $studentCount,
            'clases' => $classes
        ]]);
    }
    public function store(Request $request)
    {
        $instructor = auth()->user();
        $data = $request->validate([
            'name' => ['required', 'string', 'min:3', 'max:255'],
            'class_image' => ['required', 'file'],
            'description' => ['required', 'string', 'max:255', 'min:10'],
            'category_id' => ['required', 'integer', Rule::exists('categories', 'id')]
        ]);
        $path = $request->file('class_image')->store('class_images', 'public');
        $data['class_image'] = $path;
        $data['class_code'] = $this->generateRandomCode();
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
    private function generateRandomCode($length = 6)
    {
        $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        $charactersLength = strlen($characters);
        $randomCode = '';

        for ($i = 0; $i < $length; $i++) {
            $randomCode .= $characters[rand(0, $charactersLength - 1)];
        }

        return $randomCode;
    }
}
