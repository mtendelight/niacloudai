require "test_helper"

class JfaqsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jfaq = jfaqs(:one)
  end

  test "should get index" do
    get jfaqs_url
    assert_response :success
  end

  test "should get new" do
    get new_jfaq_url
    assert_response :success
  end

  test "should create jfaq" do
    assert_difference("Jfaq.count") do
      post jfaqs_url, params: { jfaq: { answer: @jfaq.answer, category: @jfaq.category, question: @jfaq.question } }
    end

    assert_redirected_to jfaq_url(Jfaq.last)
  end

  test "should show jfaq" do
    get jfaq_url(@jfaq)
    assert_response :success
  end

  test "should get edit" do
    get edit_jfaq_url(@jfaq)
    assert_response :success
  end

  test "should update jfaq" do
    patch jfaq_url(@jfaq), params: { jfaq: { answer: @jfaq.answer, category: @jfaq.category, question: @jfaq.question } }
    assert_redirected_to jfaq_url(@jfaq)
  end

  test "should destroy jfaq" do
    assert_difference("Jfaq.count", -1) do
      delete jfaq_url(@jfaq)
    end

    assert_redirected_to jfaqs_url
  end
end
