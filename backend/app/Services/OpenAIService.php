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
        $prompt = $context . "\n\nQuestion: " . $question;
        $response = OpenAI::chat()->create([
            'model' => 'gpt-3.5-turbo',
            'messages' => [
                ['role' => 'user', 'content' => $prompt],
            ],
        ]);

        return $response->choices[0]->message->content;
    }
    public function generateFeedback($context, $answers)
    {
        $prompt = $context . "\nAnswers: " . $answers;
        $response = OpenAI::chat()->create([
            'model' => 'gpt-3.5-turbo',
            'messages' => [
                ['role' => 'system', 'content' => $context],
                ['role' => 'user', 'content' => $answers]
            ],
        ]);

        return $response->choices[0]->message->content;
    }
}
