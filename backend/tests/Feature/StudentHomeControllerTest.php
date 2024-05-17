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
    public function testSearchData()
    {
        // Create test data
        $keyword = 'Test';
        $otherUser = User::factory()->create();

        // Create classes and a note that match the search keyword
        $excludedClass = StudyClass::factory()->create(['name' => 'Test Class']);
        $includedClass = StudyClass::factory()->create(['name' => 'Another Test Class']);
        $studentNote = StudentNote::factory()->create(['title' => 'Test Note', 'student_id' => $otherUser->id]);

        // Simulate student enrollment to exclude class
        $excludedClass->students()->attach($this->user);

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
            ->assertJsonFragment(['name' => 'Another Test Class']) // Ensure the non-enrolled class is included
            ->assertJsonMissing(['name' => 'Test Class']); // Ensure the enrolled class is excluded
    }
}
