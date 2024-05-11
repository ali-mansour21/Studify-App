<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\NoteDescription;
use App\Models\Notification;
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
    public function getNotifications()
    {
        $user_id = auth()->id();
        $notifications = Notification::where('receiver_id', $user_id)->get();
        return response()->json(['status' => 'success', 'data' => $notifications]);
    }

    public function store(Request $request)
    {
        $student_id = auth()->id();
        $data = $request->validate([
            'material_id' => ['sometimes', 'integer', 'exists:materials,id'],
            'material_title' => ['required_without:material_id', 'string', 'min:3', 'max:255'],
            'category_id' => ['required_without:material_id', 'integer', 'exists:categories,id'],
            'topic_title' => ['required', 'string', 'min:3', 'max:255'],
            'topic_description' => ['required', 'string', 'min:3']
        ]);

        if (isset($data['material_id'])) {
            $material = StudentNote::findOrFail($data['material_id']);
            $topic = new NoteDescription([
                'title' => $data['topic_title'],
                'content' => $data['topic_description']
            ]);
            $material->noteDescriptions()->save($topic);
            $message = 'Topic added to existing material successfully.';
        } else {
            $material = new StudentNote([
                'title' => $data['material_title'],
                'category_id' => $data['category_id'],
                'student_id' => $student_id
            ]);
            $material->save();

            $topic = new NoteDescription([
                'title' => $data['topic_title'],
                'content' => $data['topic_description']
            ]);
            $material->noteDescriptions()->save($topic);
            $message = 'New material and topic created successfully.';
        }

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
    private function getEnrolledClassIds($user)
    {
        return $user->studentClasses()->pluck('study_class_id')->toArray();
    }
}
