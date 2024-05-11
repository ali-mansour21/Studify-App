<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\AssignmentCorrection;
use App\Models\Faq;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use \Smalot\PdfParser\Parser;

class AIResourceController extends Controller
{
    public function submitFaqFile(Request $request)
    {
        $data = $request->validate([
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'faq_file' => ['required', 'file', 'mimes:pdf,doc,docx', 'max:10240'],
        ]);
        if ($request->has('faq_file')) {
            $file = $request->file('faq_file');
            $filename = $this->generateFileName($file);
            $path = $file->storeAs('materialsData', $filename, 'public');
            $materialFile = new Faq();
            $materialFile->material_id = $data['material_id'];
            $materialFile->file_name = $filename;
            $materialFile->file_path = $path;
            $materialFile->save();
            return response()->json(['status' => 'success', 'message' => 'Material file was successfully created']);
        }
        return response()->json(['status' => 'error', 'message' => 'File upload failed']);
    }
    public function submitCorrectionFile(Request $request)
    {
        $data = $request->validate([
            'assignment_id' => ['required', 'integer', Rule::exists('assignments', 'id')],
            'correction_file' => ['required', 'file', 'mimes:pdf,doc,docx', 'max:10240'],
        ]);
        if ($request->has('correction_file')) {
            $file = $request->file('correction_file');
            $filename = $this->generateFileName($file);
            $path = $file->storeAs('assignmentData', $filename, 'public');
            $assignmentFile = new AssignmentCorrection();
            $assignmentFile->assignment_id = $data['assignment_id'];
            $assignmentFile->file_name = $filename;
            $assignmentFile->file_path = $path;
            $assignmentFile->save();
            return response()->json(['status' => 'success', 'message' => 'Correction file was successfully created']);
        }
        return response()->json(['status' => 'error', 'message' => 'File upload failed']);
    }
    private function generateFileName($file)
    {
        $timestamp = time();
        $randomStr = bin2hex(random_bytes(5));
        return $timestamp . '_' . $randomStr . '.' . $file->getClientOriginalExtension();
    }
}
