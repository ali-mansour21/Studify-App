<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StudentNote extends Model
{
    use HasFactory;
    public function student()
    {
        return $this->belongsTo(User::class, 'student_id');
    }
    public function noteDescriptions()
    {
        return $this->hasMany(NoteDescription::class, 'note_id');
    }
    public function category()
    {
        return $this->belongsTo(Category::class);
    }
}
