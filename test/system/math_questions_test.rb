require "application_system_test_case"

class MathQuestionsTest < ApplicationSystemTestCase
  setup do
    @math_question = math_questions(:one)
  end

  test "visiting the index" do
    visit math_questions_url
    assert_selector "h1", text: "Math questions"
  end

  test "should create math question" do
    visit math_questions_url
    click_on "New math question"

    fill_in "Correct answer", with: @math_question.correct_answer
    fill_in "Option a", with: @math_question.option_a
    fill_in "Option b", with: @math_question.option_b
    fill_in "Option c", with: @math_question.option_c
    fill_in "Option d", with: @math_question.option_d
    fill_in "Question", with: @math_question.question
    click_on "Create Math question"

    assert_text "Math question was successfully created"
    click_on "Back"
  end

  test "should update Math question" do
    visit math_question_url(@math_question)
    click_on "Edit this math question", match: :first

    fill_in "Correct answer", with: @math_question.correct_answer
    fill_in "Option a", with: @math_question.option_a
    fill_in "Option b", with: @math_question.option_b
    fill_in "Option c", with: @math_question.option_c
    fill_in "Option d", with: @math_question.option_d
    fill_in "Question", with: @math_question.question
    click_on "Update Math question"

    assert_text "Math question was successfully updated"
    click_on "Back"
  end

  test "should destroy Math question" do
    visit math_question_url(@math_question)
    click_on "Destroy this math question", match: :first

    assert_text "Math question was successfully destroyed"
  end
end
