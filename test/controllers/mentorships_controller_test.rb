require "test_helper"

class MentorshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mentorship = mentorships(:one)
  end

  test "should get index" do
    get mentorships_url
    assert_response :success
  end

  test "should get new" do
    get new_mentorship_url
    assert_response :success
  end

  test "should create mentorship" do
    assert_difference("Mentorship.count") do
      post mentorships_url, params: { mentorship: { date: @mentorship.date, location: @mentorship.location, name: @mentorship.name, planned_visitors: @mentorship.planned_visitors, time: @mentorship.time } }
    end

    assert_redirected_to mentorship_url(Mentorship.last)
  end

  test "should show mentorship" do
    get mentorship_url(@mentorship)
    assert_response :success
  end

  test "should get edit" do
    get edit_mentorship_url(@mentorship)
    assert_response :success
  end

  test "should update mentorship" do
    patch mentorship_url(@mentorship), params: { mentorship: { date: @mentorship.date, location: @mentorship.location, name: @mentorship.name, planned_visitors: @mentorship.planned_visitors, time: @mentorship.time } }
    assert_redirected_to mentorship_url(@mentorship)
  end

  test "should destroy mentorship" do
    assert_difference("Mentorship.count", -1) do
      delete mentorship_url(@mentorship)
    end

    assert_redirected_to mentorships_url
  end
end
