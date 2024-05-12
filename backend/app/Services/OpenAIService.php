<?php

namespace App\Services;

use GuzzleHttp\Client;
use OpenAI\Laravel\Facades\OpenAI;

class OpenAIService
{
    protected $client;
    protected $apiKey;

    public function __construct()
    {
        $this->client = new Client();
        $this->apiKey = env('OPENAI_API_KEY');
    }

    /**
     * Send a query and context to OpenAI to generate an answer.
     *
     * @param string $context Context or content from the PDF as background information.
     * @param string $question The user's question.
     * @return string The answer from OpenAI.
     */
    public function generateAnswer($context, $question)
    {
        $messages = [];
        if (!empty($context)) {
            $messages[] = ['role' => 'system', 'content' => $context];
        }

        $messages[] = ['role' => 'user', 'content' => $question];

        $response = OpenAI::chat()->create([
            'model' => 'gpt-4',
            'messages' => $messages,
        ]);

        return $response->choices[0]->message->content;
    }
    public function generateFeedback($context, $answers)
    {
        $instructions = "Below is the assignment text with the correct answers. Please provide detailed feedback directly to the student using 'you' to address them about any mistakes made in their answers listed after the assignment.";

        $prompt = $context . "\n\n" . $instructions . "\nYour Answers:\n" . $answers;

        $response = OpenAI::chat()->create([
            'model' => 'gpt-4',
            'messages' => [
                ['role' => 'system', 'content' => $prompt]
            ],
        ]);

        return $response->choices[0]->message->content;
    }
}
