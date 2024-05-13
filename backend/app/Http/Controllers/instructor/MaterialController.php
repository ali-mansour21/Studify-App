<?php

namespace App\Http\Controllers\instructor;

use App\Events\AssignmentCreated;
use App\Events\TopicCreated;
use App\Http\Controllers\Controller;
use App\Models\Assignment;
use App\Models\Material;
use App\Models\Topic;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;
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
            'attachment' => ['nullable', 'file', 'mimes:pdf,doc,docx'],
            'type' => ['required', 'integer']
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $data = $validator->validated();

        if ($request->hasFile('attachment')) {
            $filename = $request->file('attachment')->getClientOriginalName();
            $path = $request->file('attachment')->storeAs('class_attachments', $filename);
        } else {
            $path = null;
        }

        if (intval($data['type']) == 0) {
            $topic = new Topic();
            $topic->title = $data['title'];
            $topic->content = $data['content'];
            $topic->material_id = $data['material_id'];
            $topic->save();
            event(new TopicCreated($topic));
            return response()->json(['message' => 'Topic created successfully', 'file_path' => $path], 201);
        } elseif (intval($data['type']) == 1) {
            $assignment = new Assignment();
            $assignment->title = $data['title'];
            $assignment->content = $data['content'];
            $assignment->material_id = $data['material_id'];
            $assignment->save();
            event(new AssignmentCreated($assignment));
            return response()->json(['message' => 'Assignment created successfully', 'file_path' => $path], 201);
        } else {
            return response()->json(['status' => 'error', 'message' => 'Invalid type provided'], 400);
        }
    }
}
