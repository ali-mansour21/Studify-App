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

        $this->instructor = User::factory()->create(['user_type' => 'instructor']);

        
        $this->student = User::factory()->create(['user_type' => 'student']);

        
        $this->studyClass = StudyClass::factory()->create();
    }
    public function test_instructor_can_store_material()
    {
        $token = JWTAuth::fromUser($this->instructor);
        $this->withHeaders(['Authorization' => "Bearer $token"]);

        $this->actingAs($this->instructor, 'api');

        $data = [
            'class_id' => $this->studyClass->id,
            'name' => 'New Material'
        ];

        
        $response = $this->json('POST', route('materials.store'), $data);

        
        $response->assertStatus(201);
        $response->assertJson([
            'message' => 'Material created successfully'
        ]);

        $this->assertDatabaseHas('materials', [
            'class_id' => $this->studyClass->id,
            'name' => 'New Material'
        ]);
    }
}
