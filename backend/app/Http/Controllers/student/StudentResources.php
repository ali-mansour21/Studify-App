<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class StudentResources extends Controller
{
    public function studentEnrolledClasses()
    {
        $student = auth()->user();
        $studentClasses =  $student->studentClasses()
            ->with(['materials.topics', 'materials.assignments'])
            ->get();
        return response()->json(['status' => 'success', 'data' => $studentClasses]);
    }
    public function studentCreatedNotes()
    {
        $student = auth()->user();
        $studentNotes = $student->studentNotes()
            ->with('noteDescriptions')
            ->get();
        return response()->json(['status' => 'success', 'data' => $studentNotes]);
    }
}
