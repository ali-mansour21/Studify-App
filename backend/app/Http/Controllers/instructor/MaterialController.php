<?php

namespace App\Http\Controllers\instructor;

use App\Events\AssignmentCreated;
use App\Events\TopicCreated;
use App\Http\Controllers\Controller;
use App\Models\Assignment;
use App\Models\Material;
use App\Models\Topic;
use finfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class MaterialController extends Controller
{
    public function store(Request $request)
    {
        $data = $request->validate([
            'class_id' => ['required', 'integer', Rule::exists('study_classes', 'id')],
            'name' => ['required', 'string', 'min:2', 'max:255']
        ]);
        $material =  new Material();
        $material->class_id = $data['class_id'];
        $material->name = $data['name'];
        $material->save();
        return response()->json(['message' => 'Material created successfully'], 201);
    }
    public function storeData(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'title' => ['required', 'string', 'min:3', 'max:30'],
            'content' => ['required', 'string', 'min:10'],
            'attachment' => ['nullable', 'string'],
            'type' => ['required', 'integer']
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $data = $validator->validated();

        $path = null;
        if (isset($data['attachment'])) {
            $fileData = base64_decode($data['attachment']);

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

            $filename = 'attachment_' . uniqid() . '.' . $extension;

            $path = Storage::disk('public')->put("class_attachments/{$filename}", $fileData);
        }

        if (intval($data['type']) == 0) {
            $topic = new Topic();
            $topic->title = $data['title'];
            $topic->content = $data['content'];
            $topic->material_id = $data['material_id'];
            $topic->attachment = $path;
            $topic->save();
            event(new TopicCreated($topic));
            return response()->json(['status' => 'success', 'message' => 'Topic created successfully'], 200);
        } elseif (intval($data['type']) == 1) {
            $assignment = new Assignment();
            $assignment->title = $data['title'];
            $assignment->content = $data['content'];
            $assignment->material_id = $data['material_id'];
            $assignment->attachment = $path;
            $assignment->save();
            event(new AssignmentCreated($assignment));
            return response()->json(['status' => 'success', 'message' => 'Assignment created successfully'], 200);
        } else {
            return response()->json(['status' => 'error', 'message' => 'Invalid type provided'], 400);
        }
    }
    private function generateFileName($file)
    {
        $timestamp = time();
        $randomStr = bin2hex(random_bytes(5));
        return $timestamp . '_' . $randomStr . '.' . $file->getClientOriginalExtension();
    }
}
