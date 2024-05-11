<?php

namespace App\Jobs;

use App\Models\Notification as ModelsNotification;
use App\Models\Topic;
use App\Models\User;
use App\Notifications\AccountActivated;
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
        $material = $this->topic->material;
        $class = $material->class;
        $title = "New Topic Posted";
        $content = "A new topic '{$this->topic->title}' has been created in your class '{$class->name}'.";

        $this->student->notify(new AccountActivated($title, $content));
        ModelsNotification::create([
            'content' => $content,
            'sender_id' => $class->instructor_id,
            'receiver_id' => $this->student->id,
            'type_id' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
