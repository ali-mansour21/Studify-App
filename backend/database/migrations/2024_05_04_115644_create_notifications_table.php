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
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->string('content');
            $table->foreignId('sender_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreignId('receiver_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreignId('type_id')->references('id')->on('notification_types')->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
