<?php

namespace App\Listeners;

use App\Events\TopicCreated;
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
        $messaging = app('firebase.messaging');
        $material = $event->topic->material;
        $class = $material->class;
        $students = $class->students;
        foreach ($students as $student) {
            $token = $student->firebase_token; // Ensure that each student has a firebase token stored
            if ($token) {
                $message = CloudMessage::withTarget('token', $token)
                    ->withNotification(Notification::fromArray([
                        'title' => 'New Topic Created',
                        'body' => 'A new topic has been posted in your class: ' . $event->topic->title
                    ]));

                $messaging->send($message);
            }
        }
    }
}
