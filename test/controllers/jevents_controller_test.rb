require "test_helper"

class JeventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jevent = jevents(:one)
  end

  test "should get index" do
    get jevents_url
    assert_response :success
  end

  test "should get new" do
    get new_jevent_url
    assert_response :success
  end

  test "should create jevent" do
    assert_difference("Jevent.count") do
      post jevents_url, params: { jevent: { description: @jevent.description, end: @jevent.end, jcalendar_id: @jevent.jcalendar_id, start: @jevent.start, title: @jevent.title } }
    end

    assert_redirected_to jevent_url(Jevent.last)
  end

  test "should show jevent" do
    get jevent_url(@jevent)
    assert_response :success
  end

  test "should get edit" do
    get edit_jevent_url(@jevent)
    assert_response :success
  end

  test "should update jevent" do
    patch jevent_url(@jevent), params: { jevent: { description: @jevent.description, end: @jevent.end, jcalendar_id: @jevent.jcalendar_id, start: @jevent.start, title: @jevent.title } }
    assert_redirected_to jevent_url(@jevent)
  end

  test "should destroy jevent" do
    assert_difference("Jevent.count", -1) do
      delete jevent_url(@jevent)
    end

    assert_redirected_to jevents_url
  end
end
