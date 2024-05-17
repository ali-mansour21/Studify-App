<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth as FacadesJWTAuth;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class StudentHomeControllerTest extends TestCase
{
    use RefreshDatabase;
    /**
     * A basic feature test example.
     */
    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create();
        $this->token = FacadesJWTAuth::fromUser($this->user);
    }
    public function testIndex()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson(route('resources.index'));

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'data' => [
                    'recommended_notes',
                    'recommended_classes'
                ]
            ]);
    }
}
