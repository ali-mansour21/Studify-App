<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('faq_answers', function (Blueprint $table) {
            $table->id();
            $table->string('question');
            $table->text('bot_answer');
            $table->foreignId('student_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreignId('material_id')->references('id')->on('materials')->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('faq_answers');
    }
};
