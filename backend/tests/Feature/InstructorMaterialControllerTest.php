<?php

namespace Tests\Feature;

use App\Events\AssignmentCreated;
use App\Events\TopicCreated;
use App\Models\Material;
use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Storage;
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
    public function testStoreDataCreateTopic()
    {
        Storage::fake('public');
        Event::fake();
        $material = Material::factory()->create();
        $token = JWTAuth::fromUser($this->instructor);



        $filePath = base_path('tests/files/questions.pdf');
        $this->assertFileExists($filePath, "The test file does not exist at path: $filePath");


        $file = base64_encode(file_get_contents($filePath));
        $data = [
            'material_id' => $material->id,
            'title' => 'Test Topic',
            'content' => 'This is the content of the test topic',
            'attachment' => $file,
            'type' => 0,
        ];


        $response = $this->json('POST', route('storeData'), $data, ['Authorization' => "Bearer $token"]);


        $response->assertStatus(200)
            ->assertJson(['status' => 'success', 'message' => 'Topic created successfully']);
        $responseData = json_decode($response->getContent(), true);
        $this->assertArrayHasKey('filename', $responseData, 'Filename key is missing in the response');
        $filename = $responseData['filename'];


        $this->assertDatabaseHas('topics', [
            'material_id' => $material->id,
            'title' => 'Test Topic',
            'content' => 'This is the content of the test topic',
            'attachment' =>  'class_attachments/' . $filename,
        ]);


        Storage::disk('public')->assertExists('class_attachments/' . $filename);


        Event::assertDispatched(TopicCreated::class);
    }
    public function testStoreDataCreateAssignment()
    {
        Storage::fake('public');
        Event::fake();
        $material = Material::factory()->create();
        $token = JWTAuth::fromUser($this->instructor);

        // Correct the file path and ensure the file exists
        $filePath = base_path('tests/files/questions.pdf');
        $this->assertFileExists($filePath, "The test file does not exist at path: $filePath");

        $file = base64_encode(file_get_contents($filePath));
        $data = [
            'material_id' => $material->id,
            'title' => 'Test Assignment',
            'content' => 'This is the content of the test assignment',
            'attachment' => $file,
            'type' => 1,
        ];

        
        $response = $this->json('POST', route('storeData'), $data, ['Authorization' => "Bearer $token"]);

        
        $response->assertStatus(200)
            ->assertJson(['status' => 'success', 'message' => 'Assignment created successfully']);

        
        $responseData = json_decode($response->getContent(), true);
        $this->assertArrayHasKey('filename', $responseData, 'Filename key is missing in the response');
        $filename = $responseData['filename'];

        // Verify the database entry
        $this->assertDatabaseHas('assignments', [
            'material_id' => $material->id,
            'title' => 'Test Assignment',
            'content' => 'This is the content of the test assignment',
            'attachment' => 'class_attachments/' . $filename,
        ]);

        // Verify the file exists in storage
        Storage::disk('public')->assertExists('class_attachments/' . $filename);

        // Check that the event was dispatched
        Event::assertDispatched(AssignmentCreated::class);
    }
}
