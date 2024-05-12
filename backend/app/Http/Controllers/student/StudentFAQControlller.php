<?php

namespace App\Http\Controllers\student;

use App\Http\Controllers\Controller;
use App\Models\Faq;
use App\Models\FaqAnswer;
use App\Services\OpenAIService;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class StudentFAQControlller extends Controller
{
    protected $openAIService;
    public function __construct(OpenAIService $openAIService)
    {
        $this->openAIService = $openAIService;
    }
    public function askQuestion(Request $request)
    {
        $student_id = auth()->id();
        $data = $request->validate([
            'material_id' => ['required', 'integer', Rule::exists('materials', 'id')],
            'question' => ['required', 'string']
        ]);
        $faq = Faq::where('material_id', $data['material_id'])->first();
        $context = $faq->file_text;
        $question = $data['question'];
        $bot_answer = $this->openAIService->generateAnswer($context, $question);
        $faqAnswer =  new FaqAnswer();
        $faqAnswer->question = $question;
        $faqAnswer->bot_answer = $bot_answer;
        $faqAnswer->student_id = $student_id;
        $faqAnswer->material_id = $data['material_id'];
        $faqAnswer->save();
        $studentFaqs = Faq::where('student_id', $student_id)->get();
        return response()->json(['status' => 'success', 'data' => $studentFaqs]);
    }
}
