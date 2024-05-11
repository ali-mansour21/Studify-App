<?php

namespace App\Services;

use GuzzleHttp\Client;

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
        $response = $this->client->post('https://api.openai.com/v1/completions', [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->apiKey,
                'Content-Type' => 'application/json',
            ],
            'json' => [
                'model' => 'text-davinci-002', // Use an appropriate model like "text-davinci-002"
                'prompt' => $prompt,
                'max_tokens' => 200,
                'temperature' => 0.7
            ]
        ]);

        $body = json_decode($response->getBody()->getContents(), true);
        return $body['choices'][0]['text'];
    }
}
