<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StudyClass extends Model
{
    use HasFactory;
    public function instructor()
    {
        return $this->belongsTo(User::class, 'instructor_id');
    }
    public function materials()
    {
        return $this->hasMany(Material::class);
    }
    public function students()
    {
        return $this->belongsToMany(User::class, 'class_enrollment', 'class_id', 'student_id')
            ->using(ClassEnrollment::class)
            ->withTimestamps();
    }
    public function category()
    {
        return $this->belongsTo(Category::class);
    }
    public function classRequests()
    {
        return $this->hasMany(ClassRequest::class);
    }
}
