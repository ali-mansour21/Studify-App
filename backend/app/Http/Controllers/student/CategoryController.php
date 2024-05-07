<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::all();
        return response()->json(['status' => 'success', 'data' => $categories]);
    }
    public function storeSelectedCategory(Request $request)
    {
        $user = auth()->user();
        $validated = $request->validate([
            'categories' => 'required|array',
            'categories.*' => 'exists:categories,id'
        ]);


        $user->categories()->sync($validated['categories']);
        return response()->json(['success' => 'success']);
    }
}
