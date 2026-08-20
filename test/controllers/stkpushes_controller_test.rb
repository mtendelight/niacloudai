require "test_helper"

class StkpushesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stkpush = stkpushes(:one)
  end

  test "should get index" do
    get stkpushes_url
    assert_response :success
  end

  test "should get new" do
    get new_stkpush_url
    assert_response :success
  end

  test "should create stkpush" do
    assert_difference("Stkpush.count") do
      post stkpushes_url, params: { stkpush: { amount: @stkpush.amount, modified_at: @stkpush.modified_at, phone_number: @stkpush.phone_number } }
    end

    assert_redirected_to stkpush_url(Stkpush.last)
  end

  test "should show stkpush" do
    get stkpush_url(@stkpush)
    assert_response :success
  end

  test "should get edit" do
    get edit_stkpush_url(@stkpush)
    assert_response :success
  end

  test "should update stkpush" do
    patch stkpush_url(@stkpush), params: { stkpush: { amount: @stkpush.amount, modified_at: @stkpush.modified_at, phone_number: @stkpush.phone_number } }
    assert_redirected_to stkpush_url(@stkpush)
  end

  test "should destroy stkpush" do
    assert_difference("Stkpush.count", -1) do
      delete stkpush_url(@stkpush)
    end

    assert_redirected_to stkpushes_url
  end
end
