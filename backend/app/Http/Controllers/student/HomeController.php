<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\NoteDescription;
use App\Models\Notification;
use App\Models\StudentNote;
use App\Models\StudyClass;
use App\Notifications\AccountActivated;
use GuzzleHttp\Exception\RequestException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
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
    public function searchData(Request $request)
    {
        $student_id = auth()->id();
        $data = $request->validate([
            'keyWord' => ['required', 'string']
        ]);
        $keyword = $data['keyWord'];

        $classes = StudyClass::where('name', 'LIKE', "%{$keyword}%")
            ->whereDoesntHave('students', function ($query) use ($student_id) {
                $query->where('users.id', $student_id);
            })
            ->get();

        $studyNotes = StudentNote::where('title', 'LIKE', "%{$keyword}%")
            ->where('student_id', '!=', $student_id)
            ->get();

        return response()->json(['status' => 'success', 'data' => [
            'studyNotes' => $studyNotes,
            'classes' => $classes
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
        set_time_limit(0);
        $student_id = auth()->id();
        $data = $request->validate([
            'material_id' => ['sometimes', 'integer', 'exists:materials,id'],
            'material_title' => ['required_without:material_id', 'string', 'min:3', 'max:255'],
            'category_id' => ['required_without:material_id', 'integer', 'exists:categories,id'],
            'topic_title' => ['required', 'string', 'min:3', 'max:255'],
            'text_image' => ['required', 'image']
        ]);
        if ($request->hasFile('text_image')) {
            $image = $request->file('text_image');
            $path = $image->store('notes', 'public');
            $data['text_image'] = $path;
        }
        $imageUrl = url('storage/' . $data['text_image']);
        try {
            $flaskResponse = Http::withHeader([
                'Accept' => 'application/json',
                'Content-Type' => 'application/json'
            ])->post('http://192.168.0.104:5000/process_image', [
                'image_url' => $imageUrl
            ]);

            if ($flaskResponse->successful()) {
                $extractedText = $flaskResponse->json()['text'];
            } else {
                return response()->json(['error' => 'Failed to process image on Flask server'], 500);
            }
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while processing the image: ' . $e->getMessage()], 500);
        }
        if (isset($data['material_id'])) {
            $material = StudentNote::findOrFail($data['material_id']);
            $topic = new NoteDescription([
                'title' => $data['topic_title'],
                'content' => $extractedText
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
                'content' => $extractedText
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
