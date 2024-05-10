<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\StudyClass;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
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
            'class_image' => ['required', 'string'],
            'description' => ['required', 'string', 'max:255', 'min:10'],
            'category_id' => ['required', 'integer', Rule::exists('categories', 'id')]
        ]);
        if (preg_match('/^data:image\/(\w+);base64,/', $data['class_image'], $type)) {
            $imageData = substr($data['class_image'], strpos($data['class_image'], ',') + 1);
            $type = strtolower($type[1]);

            if (!in_array($type, ['jpg', 'jpeg', 'png', 'gif'])) {
                throw new \Exception('Invalid image type');
            }

            $imageData = base64_decode($imageData);
            if ($imageData === false) {
                throw new \Exception('Base64 decode failed');
            }

            $filename = time() . '.' . $type;
            $path = 'class_images/' . $filename;
            Storage::disk('public')->put($path, $imageData);
            $data['class_image'] = $path;
        } else {
            throw new \Exception('Did not match data URI with image data');
        }
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
