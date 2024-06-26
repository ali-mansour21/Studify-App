<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubmissionFeedback extends Model
{
    use HasFactory;
    public function assignmentSubmission()
    {
        return $this->belongsTo(AssignmentSubmission::class);
    }
}
