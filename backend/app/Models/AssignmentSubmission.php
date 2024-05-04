<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AssignmentSubmission extends Model
{
    use HasFactory;
    public function assignment()
    {
        return $this->belongsTo(Assignment::class);
    }
    public function feedback(){
        return $this->hasOne(SubmissionFeedback::class);
    }
}
