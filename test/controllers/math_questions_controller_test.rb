require "test_helper"

class MathQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @math_question = math_questions(:one)
  end

  test "should get index" do
    get math_questions_url
    assert_response :success
  end

  test "should get new" do
    get new_math_question_url
    assert_response :success
  end

  test "should create math_question" do
    assert_difference("MathQuestion.count") do
      post math_questions_url, params: { math_question: { correct_answer: @math_question.correct_answer, option_a: @math_question.option_a, option_b: @math_question.option_b, option_c: @math_question.option_c, option_d: @math_question.option_d, question: @math_question.question } }
    end

    assert_redirected_to math_question_url(MathQuestion.last)
  end

  test "should show math_question" do
    get math_question_url(@math_question)
    assert_response :success
  end

  test "should get edit" do
    get edit_math_question_url(@math_question)
    assert_response :success
  end

  test "should update math_question" do
    patch math_question_url(@math_question), params: { math_question: { correct_answer: @math_question.correct_answer, option_a: @math_question.option_a, option_b: @math_question.option_b, option_c: @math_question.option_c, option_d: @math_question.option_d, question: @math_question.question } }
    assert_redirected_to math_question_url(@math_question)
  end

  test "should destroy math_question" do
    assert_difference("MathQuestion.count", -1) do
      delete math_question_url(@math_question)
    end

    assert_redirected_to math_questions_url
  end
end
