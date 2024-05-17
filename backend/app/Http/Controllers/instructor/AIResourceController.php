<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\AssignmentCorrection;
use App\Models\Faq;
use finfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use \Smalot\PdfParser\Parser;

class AIResourceController extends Controller
{
    public function submitFaqFile(Request $request)
    {
        $data = $request->validate([
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'faq_file' => ['required', 'string'],
        ]);

        if ($request->has('faq_file')) {
            $fileData = base64_decode($request->input('faq_file'));

            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $mimeType = $finfo->buffer($fileData);
            $extension = '';
            switch ($mimeType) {
                case 'application/pdf':
                    $extension = 'pdf';
                    break;
                case 'application/msword':
                    $extension = 'doc';
                    break;
                case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
                    $extension = 'docx';
                    break;
                default:
                    return response()->json(['status' => 'error', 'message' => 'Invalid file type']);
            }

            $filename = 'material_' . uniqid() . '.' . $extension;
            $path = "materialsData/{$filename}"; // Use the correct path format
            Storage::disk('public')->put($path, $fileData);

            $text = '';
            if ($extension === 'pdf') {
                $parser = new \Smalot\PdfParser\Parser();
                $pdf = $parser->parseContent($fileData);
                $text = $pdf->getText();
            }

            $materialFile = new Faq();
            $materialFile->material_id = $data['material_id'];
            $materialFile->file_name = $filename;
            $materialFile->file_path = $path;
            $materialFile->file_text = $text;
            $materialFile->save();

            return response()->json(['status' => 'success', 'message' => 'File saved successfully', 'filename' => $filename]);
        }

        return response()->json(['status' => 'error', 'message' => 'File upload failed']);
    }
    public function submitCorrectionFile(Request $request)
    {
        $data = $request->validate([
            'assignment_id' => ['required', 'integer', Rule::exists('assignments', 'id')],
            'correction_file' => ['required', 'string'], // Expect a Base64 encoded string
        ]);

        if ($request->has('correction_file')) {
            // Decode the Base64 string
            $fileData = base64_decode($request->input('correction_file'));

            // Determine the file's mime type and extension
            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mimeType = $finfo->buffer($fileData);
            $extension = '';
            switch ($mimeType) {
                case 'application/pdf':
                    $extension = 'pdf';
                    break;
                case 'application/msword':
                    $extension = 'doc';
                    break;
                case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
                    $extension = 'docx';
                    break;
                default:
                    return response()->json(['status' => 'error', 'message' => 'Invalid file type']);
            }

            // Generate a unique filename
            $filename = 'assignment_' . uniqid() . '.' . $extension;

            // Save the file to the storage
            $path = Storage::disk('public')->put("assignmentData/{$filename}", $fileData);

            // Parse the file if it's a PDF
            $text = '';
            if ($extension === 'pdf') {
                $parser = new Parser();
                $pdf = $parser->parseContent($fileData);
                $text = $pdf->getText();
            }

            // Save file information to the database
            $assignmentFile = new AssignmentCorrection();
            $assignmentFile->assignment_id = $data['assignment_id'];
            $assignmentFile->file_name = $filename;
            $assignmentFile->file_path = $path;
            $assignmentFile->file_text = $text;
            $assignmentFile->save();

            return response()->json(['status' => 'success', 'message' => 'Correction file was successfully created', 'filename' => $filename]);
        }

        return response()->json(['status' => 'error', 'message' => 'File upload failed']);
    }
}
