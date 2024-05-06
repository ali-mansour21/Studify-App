<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Assignment;
use App\Models\AssignmentSubmission;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AssignmentSubmissionController extends Controller
{
    public function submitSolution(Request $request)
    {
        $request->validate([
            'assignment_id' => ['required', Rule::exists('assignments', 'id')],
            'solution' => 'required|file|mimes:pdf,doc,docx|max:10240', // Max 10MB
        ]);

        $assignment = Assignment::findOrFail($request->assignment_id);
        $class_id = $assignment->class_id;

        $user = auth()->user();
        if (!$user->studentClasses()->where('id', $class_id)->exists()) {
            return response()->json(['message' => 'You are not enrolled in the class for this assignment.'], 403);
        }

        $file = $request->file('solution');
        $path = $file->store('submissions', 'public');

        $submission = new AssignmentSubmission([
            'student_id' => $user->id,
            'assignment_id' => $request->assignment_id,
            'file_path' => $path,
        ]);
        $submission->save();

        return response()->json(['message' => 'Assignment submitted successfully!', 'file_path' => $path]);
    }
}
