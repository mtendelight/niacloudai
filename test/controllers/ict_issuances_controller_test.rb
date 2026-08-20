require "test_helper"

class IctIssuancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ict_issuance = ict_issuances(:one)
  end

  test "should get index" do
    get ict_issuances_url
    assert_response :success
  end

  test "should get new" do
    get new_ict_issuance_url
    assert_response :success
  end

  test "should create ict_issuance" do
    assert_difference("IctIssuance.count") do
      post ict_issuances_url, params: { ict_issuance: { condition: @ict_issuance.condition, issued_on: @ict_issuance.issued_on, item_name: @ict_issuance.item_name, item_type: @ict_issuance.item_type, notes: @ict_issuance.notes, returned_on: @ict_issuance.returned_on, serial_number: @ict_issuance.serial_number, status: @ict_issuance.status, user_id: @ict_issuance.user_id } }
    end

    assert_redirected_to ict_issuance_url(IctIssuance.last)
  end

  test "should show ict_issuance" do
    get ict_issuance_url(@ict_issuance)
    assert_response :success
  end

  test "should get edit" do
    get edit_ict_issuance_url(@ict_issuance)
    assert_response :success
  end

  test "should update ict_issuance" do
    patch ict_issuance_url(@ict_issuance), params: { ict_issuance: { condition: @ict_issuance.condition, issued_on: @ict_issuance.issued_on, item_name: @ict_issuance.item_name, item_type: @ict_issuance.item_type, notes: @ict_issuance.notes, returned_on: @ict_issuance.returned_on, serial_number: @ict_issuance.serial_number, status: @ict_issuance.status, user_id: @ict_issuance.user_id } }
    assert_redirected_to ict_issuance_url(@ict_issuance)
  end

  test "should destroy ict_issuance" do
    assert_difference("IctIssuance.count", -1) do
      delete ict_issuance_url(@ict_issuance)
    end

    assert_redirected_to ict_issuances_url
  end
end
