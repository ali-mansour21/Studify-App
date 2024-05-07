<?php

namespace App\Listeners;

use App\Events\TopicCreated;
use App\Jobs\SendTopicNotificationJob;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class SendTopicNotification
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(TopicCreated $event): void
    {
        $students = $event->topic->material->class->students;
        foreach ($students as $student) {
            SendTopicNotificationJob::dispatch($student, $event->topic);
        }
    }
}
