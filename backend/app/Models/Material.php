<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Material extends Model
{
    use HasFactory;
    public function class()
    {
        return $this->belongsTo(StudyClass::class);
    }
    public function topics(){
        return $this->hasMany(Topic::class);
    }
    public function assignments(){
        return $this->hasMany(Assignment::class);
    }

}
