<?php

namespace App\Listeners;

use App\Events\ClassRequestRejected;
use App\Models\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;

class SendClassRequestRejectedNotification
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
    public function handle(ClassRequestRejected $event): void
    {
        $student = $event->classRequest->student;
        $instructor = $event->classRequest->class->instructor;

        Notification::create([
            'content' => 'Your class request has been rejected.',
            'sender_id' => $instructor->id,
            'receiver_id' => $student->id,
            'type_id' => 4
        ]);

        $messaging = app('firebase.messaging');
        $token = $student->firebase_token;

        if ($token) {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(FirebaseNotification::create(
                    'Class Request Rejected',
                    'Your class request has been rejected.'
                ));
            $messaging->send($message);
        }
    }
}
