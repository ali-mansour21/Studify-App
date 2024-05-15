<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class InviteStudentMail extends Mailable
{
    use Queueable, SerializesModels;

    public $classCode;
    public $className;

    /**
     * Create a new message instance.
     */
    public function __construct($classCode)
    {
        $this->classCode = $classCode;
        $this->className = $classCode;
    }

    /**
     * Build the message.
     */
    public function build()
    {
        return $this
            ->subject('Invite Student Mail')
            ->view('emails.inviteToClass')
            ->with([
                'classCode' => $this->classCode,
                'className' => $this->className,
            ]);
    }
}
