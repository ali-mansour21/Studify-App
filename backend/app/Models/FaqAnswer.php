<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FaqAnswer extends Model
{
    use HasFactory;
    public function materialFaq()
    {
        return $this->belongsTo(Faq::class);
    }
}
