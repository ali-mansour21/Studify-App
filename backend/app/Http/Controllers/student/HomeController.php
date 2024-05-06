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
        $student_note = StudentNote::where('title', $data['title'])
            ->where('student_id', $user_id)
            ->first();
        if ($student_note) {
            $message = 'Added new note description to existing student note.';
        }else{
            $student_note = new StudentNote([
                'title' => $data['title'],
                'category_id' => $data['category_id'],
                'student_id' => $user_id,
            ]);
            $student_note->save();
            $message = 'Successfully created a new student note.';
        }
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
