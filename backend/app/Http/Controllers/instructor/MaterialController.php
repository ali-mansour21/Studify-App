<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\Material;
use App\Models\Topic;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;
use Illuminate\Validation\Rule;

class MaterialController extends Controller
{
    public function store(Request $request)
    {
        $data = $request->validate([
            'class_id' => ['required', 'integer', Rule::exists('study_classes', 'id')],
            'class_name' => ['required', 'string', 'min:2', 'max:255']
        ]);
        $material =  new Material();
        $material->class_id = $data['class_id'];
        $material->name = $data['class_name'];
        $material->save();
        return response()->json(['message' => 'Material created successfully'], 201);
    }
    public function storeData(Request $request)
    {
        $data = $request->validate([
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'title' => ['required', 'string', 'min:3', 'max:30'],
            'content' => ['required', 'string', 'min:10'],
            'type' => ['required', 'integer']
        ]);
        if($data['type'] == 0){
            $topic = new Topic();
            $topic->title = $data['title'];
            $topic->content = $data['content'];
            $topic->material_id = $data['material_id'];
            $topic->save();
            return response()->json(['message' => 'Topic created successfully'], 201);
        }
    }
}
