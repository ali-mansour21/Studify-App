<?php

namespace Tests\Feature;

use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Tests\TestCase;

class InstructorMaterialControllerTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;

    protected $instructor;
    protected $student;
    protected $studyClass;

    public function setUp(): void
    {
        parent::setUp();

        // Create an instructor user
        $this->instructor = User::factory()->create(['user_type' => 'instructor']);

        // Create a student user
        $this->student = User::factory()->create(['user_type' => 'student']);

        // Create a study class
        $this->studyClass = StudyClass::factory()->create();
    }
    public function test_instructor_can_store_material()
    {
        $token = JWTAuth::fromUser($this->instructor);
        $this->withHeaders(['Authorization' => "Bearer $token"]);
        // Authenticate as instructor
        $this->actingAs($this->instructor, 'api');

        $data = [
            'class_id' => $this->studyClass->id,
            'name' => 'New Material'
        ];

        // Act: Call the store method
        $response = $this->json('POST', route('materials.store'), $data);

        // Assert: Check the response status and structure
        $response->assertStatus(201);
        $response->assertJson([
            'message' => 'Material created successfully'
        ]);

        // Assert: Check the material was created in the database
        $this->assertDatabaseHas('materials', [
            'class_id' => $this->studyClass->id,
            'name' => 'New Material'
        ]);
    }
}
