<?php

namespace App\Listeners;

use App\Events\RequestSent;
use App\Jobs\SendRequestNotificationJob;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class SendRequestNotification
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
    public function handle(RequestSent $event): void
    {
        SendRequestNotificationJob::dispatch($event->request->id);
    }
}
