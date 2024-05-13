<?php

namespace App\Http\Controllers\instructor;

use App\Http\Controllers\Controller;
use App\Models\ClassRequest;
use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

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
        $nbStudentPerMonth = $instructor->getEnrollmentCountsByMonth();
        $classRequestsPerStatus = $this->getClassRequestsByStatus($instructor->id);
        return response()->json(['status' => 'success', 'data' => [
            'nbStudentPerMonth' => $nbStudentPerMonth,
            'classRequestsPerStatus' => $classRequestsPerStatus
        ]]);
    }
    private function getSubmissionRate($classes)
    {
        $totalAssignments = 0;
        $totalSubmissions = 0;

        foreach ($classes as $class) {
            foreach ($class->materials as $material) {
                foreach ($material->assignments as $assignment) {
                    $totalAssignments++;
                    if (!is_null($assignment->submissions) && is_countable($assignment->submissions)) {
                        $totalSubmissions += $assignment->submissions->count();
                    }
                }
            }
        }

        return $totalAssignments > 0 ? ($totalSubmissions / $totalAssignments) * 100 : 0;
    }
    public function getClassRequestsByStatus($instructorId)
    {
        $instructor = User::with(['instructorClasses'])->find($instructorId);

        $statusCounts = [];

        if ($instructor && !empty($instructor->instructorClasses)) {
            $classIds = $instructor->instructorClasses->pluck('id');

            $aggregates = ClassRequest::select('status', DB::raw('count(*) as total'))
            ->whereIn('class_id', $classIds)
                ->groupBy('status')
                ->get();

            foreach ($aggregates as $aggregate) {
                $statusCounts[$aggregate->status] = $aggregate->total;
            }
        }

        return $statusCounts;
    }
}
