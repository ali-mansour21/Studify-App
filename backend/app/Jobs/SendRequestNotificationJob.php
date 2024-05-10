<?php

namespace App\Jobs;

use App\Models\ClassRequest;
use App\Models\Notification;
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
    protected $request_id;
    /**
     * Create a new job instance.
     */
    public function __construct($requestId)
    {
        $this->request_id = $requestId;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $messaging = app('firebase.messaging');
        $request = ClassRequest::findOrFail($this->request_id);
        $student = $request->student;
        $instructor = $request->class->instructor;

        $content = "You have a new request from {$student->name}.";

        Notification::create([
            'content' => $content,
            'sender_id' => $student->id,
            'receiver_id' => $instructor->id,
            'type_id' => 2,
        ]);

        $token = $instructor->firebase_token;
        if ($token) {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(FirebaseNotification::fromArray([
                    'title' => 'New Join Class Request',
                    'body' => $content
                ]));

            $messaging->send($message);
        }
    }
}
