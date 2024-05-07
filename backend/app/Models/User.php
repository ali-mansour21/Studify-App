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
        return $this->hasMany(StudyClass::class,'instructor_id');
    }
    public function studentClasses()
    {
        return $this->belongsToMany(StudyClass::class, 'class_enrollment', 'student_id', 'study_class_id')
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
                $totalSubmissions += $assignment->submissions->count();  // Count submissions for each assignment
            }
        }

        // Avoid division by zero
        if ($totalAssignments == 0) return 0;

        return ($totalSubmissions / $totalAssignments) * 100;  // Return the percentage rate
    }
}
