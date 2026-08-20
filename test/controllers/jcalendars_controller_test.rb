require "test_helper"

class JcalendarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jcalendar = jcalendars(:one)
  end

  test "should get index" do
    get jcalendars_url
    assert_response :success
  end

  test "should get new" do
    get new_jcalendar_url
    assert_response :success
  end

  test "should create jcalendar" do
    assert_difference("Jcalendar.count") do
      post jcalendars_url, params: { jcalendar: { color: @jcalendar.color, name: @jcalendar.name } }
    end

    assert_redirected_to jcalendar_url(Jcalendar.last)
  end

  test "should show jcalendar" do
    get jcalendar_url(@jcalendar)
    assert_response :success
  end

  test "should get edit" do
    get edit_jcalendar_url(@jcalendar)
    assert_response :success
  end

  test "should update jcalendar" do
    patch jcalendar_url(@jcalendar), params: { jcalendar: { color: @jcalendar.color, name: @jcalendar.name } }
    assert_redirected_to jcalendar_url(@jcalendar)
  end

  test "should destroy jcalendar" do
    assert_difference("Jcalendar.count", -1) do
      delete jcalendar_url(@jcalendar)
    end

    assert_redirected_to jcalendars_url
  end
end
