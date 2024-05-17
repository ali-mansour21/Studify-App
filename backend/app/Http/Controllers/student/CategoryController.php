<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

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
    public function storeImage(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        // Get the validated data
        $name = $request->input('name');
        $image = $request->file('image');

        // Generate a unique name for the image
        $imageName = Str::random(10) . '.' . $image->getClientOriginalExtension();
        $path = 'categories/' . $imageName;

        // Store the image in the 'categories' folder
        Storage::disk('public')->putFileAs('categories', $image, $imageName);

        // Save the name and image path to the Category model
        $category = new Category();
        $category->name = $name;
        $category->category_image = $path;
        $category->save();

        return response()->json(['message' => 'Image stored successfully', 'path' => $path], 201);
    }
    public function get()
    {
        $categories = Category::all();
        return response()->json(['status' => 'success', 'data' => $categories]);
    }
}
