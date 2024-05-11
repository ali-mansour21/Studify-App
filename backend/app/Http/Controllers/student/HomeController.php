<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\NoteDescription;
use App\Models\StudentNote;
use App\Models\StudyClass;
use App\Notifications\AccountActivated;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class HomeController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $user_id = $user->id;
        $categories = $user->categories;
        $student_notes = $this->fetchStudentNotes($categories, $user_id);
        $enrolledClassIds = $this->getEnrolledClassIds($user);
        $classes = $this->fetchStudyClasses($categories, $enrolledClassIds);
        return response()->json(['status' => 'success', 'data' => [
            'recommended_notes' => $student_notes,
            'recommended_classes' => $classes
        ]]);
    }

    public function store(Request $request)
    {
        $user_id = auth()->id();
        $data = $request->validate([
            'title' => ['required', 'string', 'min:3', 'max:255'],
            'category_id' => ['sometimes', 'integer', Rule::exists('categories', 'id')],
            'category_name' => ['sometimes', 'string', 'min:3', 'max:255'],
            'note_title' => ['required', 'string', 'min:3', 'max:255'],
            'note_content' => ['required', 'string']
        ]);
        $category_id = $this->resolveCategory($data);
        if (is_null($category_id)) {
            return response()->json(['status' => 'error', 'message' => 'Category is required']);
        }

        $noteResult = $this->manageStudentNote($data, $user_id, $category_id);
        $student_note = $noteResult['note'];
        $message = $noteResult['message'];

        $note_description = new NoteDescription([
            'title' => $data['note_title'],
            'content' => $data['note_content'],
            'note_id' => $student_note->id,
        ]);
        $note_description->save();

        return response()->json(['status' => 'success', 'message' => $message]);
    }

    private function fetchStudentNotes($categories, $user_id)
    {
        $categoryIds = $categories->pluck('id');

        return StudentNote::with('noteDescriptions')->where('student_id', '!=', $user_id)
            ->whereHas('category', function ($query) use ($categoryIds) {
                $query->whereIn('id', $categoryIds);
            })
            ->get();
    }
    private function fetchStudyClasses($categories, $enrolledClassIds)
    {
        $categoryIds = $categories->pluck('id');

        return StudyClass::with(['materials.topics', 'materials.assignments'])
            ->whereHas('category', function ($query) use ($categoryIds) {
                $query->whereIn('id', $categoryIds);
            })
            ->whereNotIn('id', $enrolledClassIds)
            ->get();
    }
    protected function resolveCategory($data)
    {
        if (!empty($data['category_id'])) {
            return $data['category_id'];
        } else if (!empty($data['category_name'])) {
            $category = Category::firstOrCreate(['name' => $data['category_name']]);
            return $category->id;
        } else {
            return null;
        }
    }
    protected function manageStudentNote($data, $user_id, $category_id)
    {
        $student_note = StudentNote::where('title', $data['title'])
            ->where('student_id', $user_id)
            ->first();

        if ($student_note) {
            return ['note' => $student_note, 'message' => 'Added new note description to existing student note.'];
        } else {
            $student_note = new StudentNote([
                'title' => $data['title'],
                'category_id' => $category_id,
                'student_id' => $user_id,
            ]);
            $student_note->save();
            return ['note' => $student_note, 'message' => 'Successfully created a new student note.'];
        }
    }
    private function getEnrolledClassIds($user)
    {
        return $user->studentClasses()->pluck('study_class_id')->toArray();
    }
}
