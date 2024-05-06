<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\AssignmentSubmission;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AssignmentSubmissionController extends Controller
{
    public function submitSolution(Request $request)
    {
        $request->validate([
            'assignment_id' => ['required', Rule::exists('assignments', 'id')],
            'solution' => 'required|file|mimes:pdf,doc,docx|max:10240',
        ]);

        $file = $request->file('solution');
        $path = $file->store('submissions', 'public');

        $submission = new AssignmentSubmission();
        $submission->student_id = auth()->user()->id;
        $submission->assignment_id = $request->assignment_id;
        $submission->save();

        return response()->json(['message' => 'Assignment submitted successfully!']);
    }
}
