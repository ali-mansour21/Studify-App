<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\NoteDescription;
use App\Models\StudentNote;
use App\Models\StudyClass;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class HomeController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $categories = $user->categories;
        $student_notes = $this->fetchStudentNotes($categories);
        $classes = $this->fetchStudyClasses($categories);
        return response()->json(['status' => 'success', 'data' => [
            'recommended_notes' => $student_notes,
            'recommented_classes' => $classes
        ]]);
    }
    public function store(Request $request)
    {
        $user_id = auth()->id();
        $data = $request->validate([
            'title' => ['required', 'string', 'min:3', 'max:255'],
            'category_id' => ['required', Rule::exists('categories', 'id')],
            'note_title' => ['required', 'string', 'min:3', 'max:255'],
            'note_content' => ['required', 'string']
        ]);
    }
    private function fetchStudentNotes($categories)
    {
        $categoryIds = $categories->pluck('id');

        return StudentNote::whereHas('category', function ($query) use ($categoryIds) {
            $query->whereIn('id', $categoryIds);
        })->get();
    }
    private function fetchStudyClasses($categories)
    {
        $categoryIds = $categories->pluck('id');

        return StudyClass::whereHas('category', function ($query) use ($categoryIds) {
            $query->whereIn('id', $categoryIds);
        })->get();
    }
}
