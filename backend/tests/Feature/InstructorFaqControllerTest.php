<?php

namespace Tests\Feature;

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

        // Correct the file path and ensure the file exists
        $filePath = base_path('tests/files/questions.pdf');
        $this->assertFileExists($filePath, "The test file does not exist at path: $filePath");

        // Encode the file in base64
        $file = base64_encode(file_get_contents($filePath));
        $data = [
            'material_id' => $material->id,
            'faq_file' => $file,
        ];
        // Send the request with the proper Authorization header
        $response = $this->json('POST', route('submitFaqFile'), $data, ['Authorization' => "Bearer $token"]);


        // Check the response
        $response->assertStatus(200)
            ->assertJson(['status' => 'success', 'message' => 'File saved successfully']);

        // Get the filename from the response
        $filename = json_decode($response->getContent(), true)['filename'];

        // Verify the database entry
        $this->assertDatabaseHas('faqs', [
            'material_id' => $material->id,
            'file_name' => $filename,
            'file_path' => 'materialsData/' . $filename,
        ]);

        // Verify the file exists in storage
        Storage::disk('public')->assertExists('materialsData/' . $filename);
    }
}
