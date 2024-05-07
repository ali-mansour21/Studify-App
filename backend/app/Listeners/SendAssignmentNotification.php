<?php

namespace App\Listeners;

use App\Events\AssignmentCreated;
use App\Jobs\SendAssignmentNotificationJob;
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
    public function handle(AssignmentCreated $event)
    {
        $students = $event->assignment->material->class->students;

        foreach ($students as $student) {
            SendAssignmentNotificationJob::dispatch($student, $event->assignment);
        }
    }
}
