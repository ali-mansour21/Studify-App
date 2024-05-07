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
        return $this->hasMany(StudyClass::class);
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
        return $this->classesTeaching()
            ->with('students')
            ->get()
            ->pluck('students')
            ->flatten()
            ->unique('id')
            ->count();
    }
}
