require "test_helper"

class WoStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wo_status = wo_statuses(:one)
  end

  test "should get index" do
    get wo_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_wo_status_url
    assert_response :success
  end

  test "should create wo_status" do
    assert_difference("WoStatus.count") do
      post wo_statuses_url, params: { wo_status: { name: @wo_status.name } }
    end

    assert_redirected_to wo_status_url(WoStatus.last)
  end

  test "should show wo_status" do
    get wo_status_url(@wo_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_wo_status_url(@wo_status)
    assert_response :success
  end

  test "should update wo_status" do
    patch wo_status_url(@wo_status), params: { wo_status: { name: @wo_status.name } }
    assert_redirected_to wo_status_url(@wo_status)
  end

  test "should destroy wo_status" do
    assert_difference("WoStatus.count", -1) do
      delete wo_status_url(@wo_status)
    end

    assert_redirected_to wo_statuses_url
  end
end
