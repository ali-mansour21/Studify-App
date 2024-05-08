<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\Faq;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AIResourceController extends Controller
{
    public function submitFaqFile(Request $request)
    {
        $data = $request->validate([
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'faq_file' => ['required', 'file', 'mimes:pdf,doc,docx', 'max:10240'],
        ]);
        if($request->has('faq_file')){
            $file = $request->file('faq_file');
            $filename = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('materialsData', $filename, 'public');
            $materialFile = new Faq();
            $materialFile->material_id = $data['material_id'];
            $materialFile->file_name = $filename;
            $materialFile->file_path = $path;
            $materialFile->save();
        }
        return response()->json(['status' => 'success']);
    }
}
