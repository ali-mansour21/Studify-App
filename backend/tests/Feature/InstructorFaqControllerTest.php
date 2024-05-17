<?php

namespace Tests\Feature;

use App\Models\Assignment;
use App\Models\Material;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Storage;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Tests\TestCase;

class InstructorFaqControllerTest extends TestCase
{
    use RefreshDatabase;
    protected $faker;
    /**
     * A basic feature test example.
     */
    public function setUp(): void
    {
        parent::setUp();
        $this->faker = \Faker\Factory::create();
    }
    private function createInstructorUser()
    {
        return User::factory()->create(['user_type' => 'instructor']);
    }

    private function createTokenForUser($user)
    {
        return JWTAuth::fromUser($user);
    }
    public function testSubmitFaqFileValidPdf()
    {
        Storage::fake('public');
        $material = Material::factory()->create();
        $instructor = $this->createInstructorUser();
        $token = $this->createTokenForUser($instructor);


        $filePath = base_path('tests/files/questions.pdf');
        $this->assertFileExists($filePath, "The test file does not exist at path: $filePath");

        
        $file = base64_encode(file_get_contents($filePath));
        $data = [
            'material_id' => $material->id,
            'faq_file' => $file,
        ];

        $response = $this->json('POST', route('submitFaqFile'), $data, ['Authorization' => "Bearer $token"]);

        $response->assertStatus(200)
            ->assertJson(['status' => 'success', 'message' => 'File saved successfully']);

        $filename = json_decode($response->getContent(), true)['filename'];

        $this->assertDatabaseHas('faqs', [
            'material_id' => $material->id,
            'file_name' => $filename,
            'file_path' => 'materialsData/' . $filename,
        ]);

        Storage::disk('public')->assertExists('materialsData/' . $filename);
    }
    public function testSubmitCorrectionFileValidPdf()
    {
        Storage::fake('public');
        $assignment = Assignment::factory()->create();
        $instructor = $this->createInstructorUser();
        $token = $this->createTokenForUser($instructor);

        
        $filePath = base_path('tests/files/questions.pdf');
        $this->assertFileExists($filePath, "The test file does not exist at path: $filePath");


        $file = base64_encode(file_get_contents($filePath));
        $data = [
            'assignment_id' => $assignment->id,
            'correction_file' => $file,
        ];

        
        $response = $this->json('POST', route('submitCorrectionFile'), $data, ['Authorization' => "Bearer $token"]);


        $response->assertStatus(200)
            ->assertJson(['status' => 'success', 'message' => 'Correction file was successfully created']);

        $responseData = json_decode($response->getContent(), true);
        $this->assertArrayHasKey('filename', $responseData, 'Filename key is missing in the response');
        $filename = $responseData['filename'];

        $this->assertDatabaseHas('assignment_corrections', [
            'assignment_id' => $assignment->id,
            'file_name' => $filename,
            'file_path' => 'assignmentData/' . $filename,
        ]);

        Storage::disk('public')->assertExists('assignmentData/' . $filename);
    }
}
