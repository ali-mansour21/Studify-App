<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        $instructor_id = auth()->id();
        $instructor = User::findOrFail($instructor_id);
        $numClasses = StudyClass::where('instructor_id', $instructor_id)->count();
        $studentCount = $instructor->getUniqueStudentCount();
        $classes = $instructor->instructorClasses()->with('materials.assignments.submissions')->get();
        $submissionRate = $this->getSubmissionRate($classes);
        return response()->json(['status' => 'success', 'data' => [
            'nbOfClasses' => $numClasses,
            'nbOfStudents' => $studentCount,
            'submissionRate' => $submissionRate,
        ]]);
    }
    public function chartData()
    {
        $instructor = auth()->user();
        $nbStudentPerMonth = $instructor->getEnrollmentCountsByMonth;
    }
    private function getSubmissionRate($classes)
    {
        $totalAssignments = 0;
        $totalSubmissions = 0;

        foreach ($classes as $class) {
            foreach ($class->materials as $material) {
                foreach ($material->assignments as $assignment) {
                    $totalAssignments++;
                    $totalSubmissions += $assignment->submissions->count();
                }
            }
        }

        return $totalAssignments > 0 ? ($totalSubmissions / $totalAssignments) * 100 : 0;
    }
}
