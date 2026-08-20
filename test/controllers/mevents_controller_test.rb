require "test_helper"

class MeventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mevent = mevents(:one)
  end

  test "should get index" do
    get mevents_url
    assert_response :success
  end

  test "should get new" do
    get new_mevent_url
    assert_response :success
  end

  test "should create mevent" do
    assert_difference("Mevent.count") do
      post mevents_url, params: { mevent: { description: @mevent.description, end_time: @mevent.end_time, mcalendar_id: @mevent.mcalendar_id, start_time: @mevent.start_time, title: @mevent.title } }
    end

    assert_redirected_to mevent_url(Mevent.last)
  end

  test "should show mevent" do
    get mevent_url(@mevent)
    assert_response :success
  end

  test "should get edit" do
    get edit_mevent_url(@mevent)
    assert_response :success
  end

  test "should update mevent" do
    patch mevent_url(@mevent), params: { mevent: { description: @mevent.description, end_time: @mevent.end_time, mcalendar_id: @mevent.mcalendar_id, start_time: @mevent.start_time, title: @mevent.title } }
    assert_redirected_to mevent_url(@mevent)
  end

  test "should destroy mevent" do
    assert_difference("Mevent.count", -1) do
      delete mevent_url(@mevent)
    end

    assert_redirected_to mevents_url
  end
end
