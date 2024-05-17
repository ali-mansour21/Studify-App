<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class StudyClass extends Model
{
    use HasFactory;
    protected $table = 'study_classes';
    protected $fillable = ['name', 'class_image', 'description', 'class_code', 'category_id'];
    public function instructor()
    {
        return $this->belongsTo(User::class, 'instructor_id');
    }
    public function materials()
    {
        return $this->hasMany(Material::class, 'class_id');
    }
    public function students(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'class_enrollments', 'study_class_id', 'student_id')
        ->using(ClassEnrollment::class)
            ->withTimestamps();
    }
    public function category()
    {
        return $this->belongsTo(Category::class);
    }
    public function classRequests()
    {
        return $this->hasMany(ClassRequest::class, 'class_id');
    }
}
