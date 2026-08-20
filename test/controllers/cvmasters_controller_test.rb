require "test_helper"

class CvmastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cvmaster = cvmasters(:one)
  end

  test "should get index" do
    get cvmasters_url
    assert_response :success
  end

  test "should get new" do
    get new_cvmaster_url
    assert_response :success
  end

  test "should create cvmaster" do
    assert_difference("Cvmaster.count") do
      post cvmasters_url, params: { cvmaster: { eight: @cvmaster.eight, five: @cvmaster.five, four: @cvmaster.four, one: @cvmaster.one, position: @cvmaster.position, resume: @cvmaster.resume, seven: @cvmaster.seven, shortlist_id: @cvmaster.shortlist_id, six: @cvmaster.six, three: @cvmaster.three, two: @cvmaster.two, username: @cvmaster.username } }
    end

    assert_redirected_to cvmaster_url(Cvmaster.last)
  end

  test "should show cvmaster" do
    get cvmaster_url(@cvmaster)
    assert_response :success
  end

  test "should get edit" do
    get edit_cvmaster_url(@cvmaster)
    assert_response :success
  end

  test "should update cvmaster" do
    patch cvmaster_url(@cvmaster), params: { cvmaster: { eight: @cvmaster.eight, five: @cvmaster.five, four: @cvmaster.four, one: @cvmaster.one, position: @cvmaster.position, resume: @cvmaster.resume, seven: @cvmaster.seven, shortlist_id: @cvmaster.shortlist_id, six: @cvmaster.six, three: @cvmaster.three, two: @cvmaster.two, username: @cvmaster.username } }
    assert_redirected_to cvmaster_url(@cvmaster)
  end

  test "should destroy cvmaster" do
    assert_difference("Cvmaster.count", -1) do
      delete cvmaster_url(@cvmaster)
    end

    assert_redirected_to cvmasters_url
  end
end
