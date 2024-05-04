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
    public function materials(){
        return $this->hasMany(Material::class);
    }
}
