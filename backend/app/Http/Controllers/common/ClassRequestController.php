<?php

namespace App\Http\Controllers\common;

use App\Events\RequestSent;
use App\Http\Controllers\Controller;
use App\Models\ClassRequest;
use App\Models\StudyClass;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ClassRequestController extends Controller
{
    public function enrollWithCode(Request $request)
    {
        $request->validate([
            'class_code' => ['required', 'string', Rule::exists('study_class', 'class_code')],
        ]);

        $class = StudyClass::where('class_code', $request->class_code)->first();

        if (!$class) {
            return response()->json(['message' => 'Invalid class code provided'], 404);
        }

        $user = auth()->user();
        if ($user->studentClasses()->where('study_classes.id', $class->id)->exists()) {
            return response()->json(['message' => 'You are already enrolled in this class'], 409);
        }


        $user->studentClasses()->attach($class->id);

        return response()->json(['message' => 'Enrolled in class successfully'], 201);
    }
    public function requestJoin(Request $request)
    {
        $request->validate([
            'class_id' => ['required', Rule::exists('study_classes', 'id')],
        ]);

        $classRequest = new ClassRequest();
        $classRequest->student_id = auth()->id();
        $classRequest->class_id = $request->class_id;
        $classRequest->save();
        event(new RequestSent($request));
        return response()->json(['message' => 'Request to join class sent successfully'], 201);
    }
}
