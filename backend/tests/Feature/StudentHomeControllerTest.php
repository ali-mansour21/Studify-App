<?php

namespace Tests\Feature;

use App\Models\StudentNote;
use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth as FacadesJWTAuth;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class StudentHomeControllerTest extends TestCase
{
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
    public function testSearchData()
    {
        $keyword = 'Test';
        $otherUser = User::factory()->create();

        $studyClass = StudyClass::factory()->create(['name' => 'Test Class']);
        $studentNote = StudentNote::factory()->create(['title' => 'Test Note', 'student_id' => $otherUser->id]);

        $studyClass->students()->attach($this->user);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson(route('resources.search'), ['keyWord' => $keyword]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'data' => [
                    'studyNotes',
                    'classes'
                ]
            ])
            ->assertJsonFragment(['title' => 'Test Note'])
            ->assertJsonMissing(['name' => 'Test Class']);
    }
}
