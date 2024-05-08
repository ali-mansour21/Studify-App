<?php

namespace App\Listeners;

use App\Events\ClassRequestApproved;
use App\Models\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;

class SendClassRequestApprovedNotification
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
    public function handle(ClassRequestApproved $event): void
    {
        $student = $event->classRequest->student;
        $instructor = $event->classRequest->class->instructor;

        Notification::create([
            'content' => 'Your class request has been approved.',
            'sender_id' => $instructor->id,
            'receiver_id' => $student->id,
            'type_id' => 4,
            'created_at' => now(),
            'updated_at' => now()
        ]);
        $messaging = app('firebase.messaging');
        $token = $student->firebase_token;
        if ($token) {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(FirebaseNotification::create(
                    'Class Request Approved',
                    'Your class request has been approved.'
                ));
            $messaging->send($message);
        }
    }
}
