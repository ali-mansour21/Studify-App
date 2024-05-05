<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            ['name' => 'Mathematics', 'category_image' => 'images/categories/mathematics.jpg'],
            ['name' => 'Science', 'category_image' => 'images/categories/science.jpg'],
            ['name' => 'History', 'category_image' => 'images/categories/history.jpg'],
            ['name' => 'English', 'category_image' => 'images/categories/english.jpg'],
            ['name' => 'Art', 'category_image' => 'images/categories/art.jpg'],
            ['name' => 'Computer Science', 'category_image' => 'images/categories/computer_science.jpg']
        ];

        DB::table('categories')->insert($categories);
    }
}
