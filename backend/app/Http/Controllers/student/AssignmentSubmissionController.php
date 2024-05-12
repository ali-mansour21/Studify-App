<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Assignment;
use App\Models\AssignmentCorrection;
use App\Models\AssignmentSubmission;
use App\Models\SubmissionFeedback;
use App\Services\OpenAIService;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use \Smalot\PdfParser\Parser;

class AssignmentSubmissionController extends Controller
{
    protected $openAIService;
    public function __construct(OpenAIService $openAIService)
    {
        $this->openAIService = $openAIService;
    }
    public function submitSolution(Request $request)
    {
        $request->validate([
            'assignment_id' => ['required', Rule::exists('assignments', 'id')],
            'solution' => 'required|file|mimes:pdf,doc,docx|max:10240',
        ]);

        $assignment = Assignment::findOrFail(intval($request->assignment_id));
        $class_id = $assignment->class_id;

        $user = auth()->user();
        if (!$user->studentClasses()->where('id', $class_id)->exists()) {
            return response()->json(['message' => 'You are not enrolled in the class for this assignment.'], 403);
        }

        $file = $request->file('solution');
        $path = $file->store('submissions', 'public');
        $parser = new Parser();
        $pdf = $parser->parseFile($request->solution);
        $answers = $pdf->getText();
        $submission = new AssignmentSubmission([
            'student_id' => $user->id,
            'assignment_id' => $request->assignment_id,
            'solution' => $path,
        ]);
        $submission->save();
        $correction_file = AssignmentCorrection::where('assignment_id', $request->assignment_id)->first();
        if ($correction_file) {
            $content = $correction_file->file_text;
            $feedback = $this->openAIService->generateFeedback($content, $answers);
            $submission_feedback = new SubmissionFeedback();
            $submission_feedback->feedback = $feedback;
            $submission_feedback->assignment_id = $request->assignment_id;
            $submission_feedback->save();
        }
        return response()->json(['status' => 'success', 'message' => 'Assignment submitted successfully!', 'date' => $submission_feedback]);
    }
}
