<?php

namespace App\Jobs;

use App\Models\Assignment;
use App\Models\Notification as ModelsNotification;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class SendAssignmentNotificationJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $student;
    protected $assignment;

    public function __construct(User $student, Assignment $assignment)
    {
        $this->student = $student;
        $this->assignment = $assignment;
    }

    public function handle()
    {
        $messaging = app('firebase.messaging');
        $content = "An assignment '{$this->assignment->title}' has been posted in your class.";
        $material = $this->assignment->material();
        $class = $material->class();
        $token = $this->student->firebase_token;

        ModelsNotification::create([
            'content' => $content,
            'sender_id' => $class->instructor_id,
            'receiver_id' => $this->student->id,
            'type_id' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($token) {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(Notification::fromArray([
                    'title' => 'New Assignment Created',
                    'body' => $content
                ]));
            $messaging->send($message);
        }
    }
}
