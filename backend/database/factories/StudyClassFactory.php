<?php

namespace Database\Factories;

use App\Models\Category;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\StudyClass>
 */
class StudyClassFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => $this->faker->words(3, true),
            'class_image' => $this->faker->paragraph,
            'description' => $this->faker->sentence,
            'instructor_id' => User::factory(),
            'category_id' => Category::factory(),
            'class_code' => $this->faker->unique()->randomKey
        ];
    }
}
