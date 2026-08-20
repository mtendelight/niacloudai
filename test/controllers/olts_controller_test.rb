require "test_helper"

class OltsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @olt = olts(:one)
  end

  test "should get index" do
    get olts_url
    assert_response :success
  end

  test "should get new" do
    get new_olt_url
    assert_response :success
  end

  test "should create olt" do
    assert_difference("Olt.count") do
      post olts_url, params: { olt: { caretaker: @olt.caretaker, description: @olt.description, latitude: @olt.latitude, location: @olt.location, longitude: @olt.longitude, name: @olt.name } }
    end

    assert_redirected_to olt_url(Olt.last)
  end

  test "should show olt" do
    get olt_url(@olt)
    assert_response :success
  end

  test "should get edit" do
    get edit_olt_url(@olt)
    assert_response :success
  end

  test "should update olt" do
    patch olt_url(@olt), params: { olt: { caretaker: @olt.caretaker, description: @olt.description, latitude: @olt.latitude, location: @olt.location, longitude: @olt.longitude, name: @olt.name } }
    assert_redirected_to olt_url(@olt)
  end

  test "should destroy olt" do
    assert_difference("Olt.count", -1) do
      delete olt_url(@olt)
    end

    assert_redirected_to olts_url
  end
end
