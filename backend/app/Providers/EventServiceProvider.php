<?php

namespace App\Providers;

use App\Events\AssignmentCreated;
use App\Events\ClassRequestApproved;
use App\Events\ClassRequestRejected;
use App\Events\RequestSent;
use App\Events\TopicCreated;
use App\Listeners\SendAssignmentNotification;
use App\Listeners\SendClassRequestApprovedNotification;
use App\Listeners\SendClassRequestRejectedNotification;
use App\Listeners\SendRequestNotification;
use App\Listeners\SendTopicNotification;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Event;

class EventServiceProvider extends ServiceProvider
{
    /**
     * The event to listener mappings for the application.
     *
     * @var array<class-string, array<int, class-string>>
     */
    protected $listen = [
        Registered::class => [
            SendEmailVerificationNotification::class,
        ],
    ];

    /**
     * Register any events for your application.
     */
    public function boot(): void
    {
        parent::boot();
        Event::listen(AssignmentCreated::class, [SendAssignmentNotification::class, 'handle']);
        Event::listen(TopicCreated::class, [SendTopicNotification::class, 'handle']);
        Event::listen(RequestSent::class, [SendRequestNotification::class, 'handle']);
        Event::listen(ClassRequestApproved::class, [SendClassRequestApprovedNotification::class, 'handle']);
        Event::listen(ClassRequestRejected::class, [SendClassRequestRejectedNotification::class, 'handle']);
    }

    /**
     * Determine if events and listeners should be automatically discovered.
     */
    public function shouldDiscoverEvents(): bool
    {
        return false;
    }
}
