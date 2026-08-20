require "test_helper"

class MattendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mattendance = mattendances(:one)
  end

  test "should get index" do
    get mattendances_url
    assert_response :success
  end

  test "should get new" do
    get new_mattendance_url
    assert_response :success
  end

  test "should create mattendance" do
    assert_difference("Mattendance.count") do
      post mattendances_url, params: { mattendance: { location: @mattendance.location, mentorship_id: @mattendance.mentorship_id, name: @mattendance.name, phone: @mattendance.phone } }
    end

    assert_redirected_to mattendance_url(Mattendance.last)
  end

  test "should show mattendance" do
    get mattendance_url(@mattendance)
    assert_response :success
  end

  test "should get edit" do
    get edit_mattendance_url(@mattendance)
    assert_response :success
  end

  test "should update mattendance" do
    patch mattendance_url(@mattendance), params: { mattendance: { location: @mattendance.location, mentorship_id: @mattendance.mentorship_id, name: @mattendance.name, phone: @mattendance.phone } }
    assert_redirected_to mattendance_url(@mattendance)
  end

  test "should destroy mattendance" do
    assert_difference("Mattendance.count", -1) do
      delete mattendance_url(@mattendance)
    end

    assert_redirected_to mattendances_url
  end
end
