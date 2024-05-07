<?php

namespace App\Listeners;

use App\Events\AssignmentCreated;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
class SendAssignmentNotification
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
    public function handle(AssignmentCreated $event): void
    {
        $messaging = app('firebase.messaging');
        $material = $event->assignment->material;
        $class = $material->class;

        foreach ($class->students as $student) {
            $token = $student->firebase_token;
            if ($token) {
                $message = CloudMessage::withTarget('token', $token)
                    ->withNotification(Notification::fromArray([
                        'title' => 'New Assignment Created',
                        'body' => "An assignment '{$event->assignment->title}' has been posted in your class: {$class->name}"
                    ]));

                $messaging->send($message);
            }
        }
    }
}
