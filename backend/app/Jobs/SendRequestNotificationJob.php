<?php

namespace App\Jobs;

use App\Models\ClassRequest;
use App\Models\Notification;
use App\Notifications\AccountActivated;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;

class SendRequestNotificationJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    protected $request;
    /**
     * Create a new job instance.
     */
    public function __construct($request)
    {
        $this->request = $request;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $request = ClassRequest::findOrFail($this->request->id);
        $student = $request->student;
        $instructor = $request->class->instructor;
        $title = "New Join Class Request";
        $content = "You have a new request from {$student->name}.";

        Notification::create([
            'content' => $content,
            'sender_id' => $student->id,
            'receiver_id' => $instructor->id,
            'type_id' => 2,
        ]);
        $instructor->notify(new AccountActivated($title, $content));
    }
}
