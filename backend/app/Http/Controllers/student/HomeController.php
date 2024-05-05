<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\StudentNote;
use App\Models\StudyClass;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $categories = $user->categories;
        $student_notes = $this->fetchStudentNotes($categories);
        $classes = $this->fetchStudyClasses($categories);
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
