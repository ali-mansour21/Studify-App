<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;
    public function users()
    {
        return $this->belongsToMany(User::class, 'user_categories', 'category_id', 'student_id');
    }
    public function studyClasses()
    {
        return $this->hasMany(StudyClass::class);
    }
    public function studentNotes()
    {
        return $this->hasMany(StudentNote::class);
    }
}
