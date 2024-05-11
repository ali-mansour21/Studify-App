<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }
    public function studentNotes()
    {
        return $this->hasMany(StudentNote::class);
    }
    public function instructorClasses()
    {
        return $this->hasMany(StudyClass::class, 'instructor_id');
    }
    public function studentClasses()
    {
        return $this->belongsToMany(StudyClass::class, 'class_enrollments', 'student_id', 'study_class_id')
            ->using(ClassEnrollment::class)
            ->withTimestamps();
    }
    public function categories()
    {
        return $this->belongsToMany(Category::class, 'user_categories', 'student_id', 'category_id');
    }
    public function getUniqueStudentCount()
    {
        return $this->instructorClasses()
            ->with('students')
            ->get()
            ->pluck('students')
            ->flatten()
            ->unique('id')
            ->count();
    }
    public function calculateSubmissionRate()
    {
        $classes = $this->instructorClasses()->with('assignments.submissions')->get();

        $totalAssignments = 0;
        $totalSubmissions = 0;

        foreach ($classes as $class) {
            foreach ($class->assignments as $assignment) {
                $totalAssignments++;
                $totalSubmissions += $assignment->submissions->count();
            }
        }

        if ($totalAssignments == 0) return 0;

        return ($totalSubmissions / $totalAssignments) * 100;
    }
    public function getEnrollmentCountsByMonth()
    {
        $enrollmentCounts = [];
        $currentYear = now()->year;

        for ($month = 1; $month <= 12; $month++) {
            $startDate = now()->setYear($currentYear)->setMonth($month)->startOfMonth();
            $endDate = now()->setYear($currentYear)->setMonth($month)->endOfMonth();

            $count = $this->instructorClasses()
                ->join('class_enrollments', 'study_classes.id', '=', 'class_enrollment.study_class_id')
                ->whereBetween('class_enrollment.created_at', [$startDate, $endDate])
                ->distinct()
                ->count('class_enrollment.student_id');

            $monthName = $startDate->format('M');
            $enrollmentCounts[$monthName] = $count;
        }

        return $enrollmentCounts;
    }
    public function routeNotificationForFcm()
    {
        return $this->firebase_token;
    }
}
