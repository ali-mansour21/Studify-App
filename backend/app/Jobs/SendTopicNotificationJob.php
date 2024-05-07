<?php

namespace App\Jobs;

use App\Models\Notification as ModelsNotification;
use App\Models\Topic;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class SendTopicNotificationJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $student;
    protected $topic;

    public function __construct(User $student, Topic $topic)
    {
        $this->student = $student;
        $this->topic = $topic;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $messaging = app('firebase.messaging');
        $content = "A topic '{$this->topic->title}' has been posted in your class.";
        $material = $this->topic->material();
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
                    'title' => 'New Topic Created',
                    'body' => $content
                ]));
            $messaging->send($message);
        }
    }
}
