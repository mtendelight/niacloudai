require "test_helper"

class JanomaxleadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @janomaxlead = janomaxleads(:one)
  end

  test "should get index" do
    get janomaxleads_url
    assert_response :success
  end

  test "should get new" do
    get new_janomaxlead_url
    assert_response :success
  end

  test "should create janomaxlead" do
    assert_difference("Janomaxlead.count") do
      post janomaxleads_url, params: { janomaxlead: { calls_count: @janomaxlead.calls_count, comments: @janomaxlead.comments, customer_exists: @janomaxlead.customer_exists, jmcustomer_id: @janomaxlead.jmcustomer_id, last_called_at: @janomaxlead.last_called_at, last_status: @janomaxlead.last_status, lead_status: @janomaxlead.lead_status, phone: @janomaxlead.phone } }
    end

    assert_redirected_to janomaxlead_url(Janomaxlead.last)
  end

  test "should show janomaxlead" do
    get janomaxlead_url(@janomaxlead)
    assert_response :success
  end

  test "should get edit" do
    get edit_janomaxlead_url(@janomaxlead)
    assert_response :success
  end

  test "should update janomaxlead" do
    patch janomaxlead_url(@janomaxlead), params: { janomaxlead: { calls_count: @janomaxlead.calls_count, comments: @janomaxlead.comments, customer_exists: @janomaxlead.customer_exists, jmcustomer_id: @janomaxlead.jmcustomer_id, last_called_at: @janomaxlead.last_called_at, last_status: @janomaxlead.last_status, lead_status: @janomaxlead.lead_status, phone: @janomaxlead.phone } }
    assert_redirected_to janomaxlead_url(@janomaxlead)
  end

  test "should destroy janomaxlead" do
    assert_difference("Janomaxlead.count", -1) do
      delete janomaxlead_url(@janomaxlead)
    end

    assert_redirected_to janomaxleads_url
  end
end
