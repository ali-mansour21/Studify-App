<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NoteDescription extends Model
{
    use HasFactory;
    protected $fillable = ['title', 'content', 'note_id'];
    public function studentNote()
    {
        return $this->belongsTo(StudentNote::class);
    }
}
