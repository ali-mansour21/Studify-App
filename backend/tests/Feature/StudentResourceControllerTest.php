<?php

namespace Tests\Feature;

use App\Models\StudentNote;
use App\Models\StudyClass;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Auth;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Tests\TestCase;

class StudentResourceControllerTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;
    protected $student;

    public function setUp(): void
    {
        parent::setUp();

        $this->student = User::factory()->create([
            'user_type' => 'student',
        ]);

        $this->actingAs($this->student, 'api');
    }
    // protected function mockAuthFacade()
    // {
    //     $guard = \Mockery::mock(\Illuminate\Contracts\Auth\Guard::class);
    //     $guard->shouldReceive('user')->andReturn($this->student);

    //     $authManager = \Mockery::mock(\Illuminate\Auth\AuthManager::class);
    //     $authManager->shouldReceive('guard')->andReturn($guard);
    //     $authManager->shouldReceive('userResolver')->andReturn(function () use ($guard) {
    //         return $guard->user();
    //     });

    //     Auth::swap($authManager);
    // }

    public function test_student_enrolled_classes()
    {
        $token = JWTAuth::fromUser($this->student);
        $this->withHeaders(['Authorization' => "Bearer $token"]);

        $class1 = StudyClass::factory()->create();
        $class2 = StudyClass::factory()->create();

        $this->student->studentClasses()->attach([$class1->id, $class2->id]);

        $class1->materials()->createMany([
            ['name' => 'Material 1'],
            ['name' => 'Material 2']
        ]);

        $class2->materials()->createMany([
            ['name' => 'Material 3'],
            ['name' => 'Material 4']
        ]);

        $response = $this->json('GET', route('student.enrolled.classes'));

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'status',
            'data' => [
                '*' => [
                    'id',
                    'name',
                    'materials' => [
                        '*' => [
                            'id',
                            'name',
                            'topics',
                            'assignments'
                        ]
                    ]
                ]
            ]
        ]);
    }
    public function test_student_created_notes()
    {
        $token = JWTAuth::fromUser($this->student);
        $this->withHeaders(['Authorization' => "Bearer $token"]);
        // Arrange: Create some student notes with related note descriptions
        $note1 = StudentNote::factory()->create(['student_id' => $this->student->id]);
        $note2 = StudentNote::factory()->create(['student_id' => $this->student->id]);

        $note1->noteDescriptions()->createMany([
            ['title' => 'Title 1', 'content' => 'Description 1'],
            ['title' => 'Title 2', 'content' => 'Description 2']
        ]);

        $note2->noteDescriptions()->createMany([
            ['title' => 'Title 3', 'content' => 'Description 3'],
            ['title' => 'Title 4', 'content' => 'Description 4']
        ]);

        $response = $this->json('GET', route('student.created.notes'));

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'status',
            'data' => [
                '*' => [
                    'id',
                    'title',
                    'note_descriptions' => [
                        '*' => [
                            'id',
                            'title',
                            'content'
                        ]
                    ]
                ]
            ]
        ]);
    }
}
