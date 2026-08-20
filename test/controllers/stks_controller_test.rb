require "test_helper"

class StksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stk = stks(:one)
  end

  test "should get index" do
    get stks_url
    assert_response :success
  end

  test "should get new" do
    get new_stk_url
    assert_response :success
  end

  test "should create stk" do
    assert_difference("Stk.count") do
      post stks_url, params: { stk: { amount: @stk.amount, modified_at: @stk.modified_at, phone_number: @stk.phone_number } }
    end

    assert_redirected_to stk_url(Stk.last)
  end

  test "should show stk" do
    get stk_url(@stk)
    assert_response :success
  end

  test "should get edit" do
    get edit_stk_url(@stk)
    assert_response :success
  end

  test "should update stk" do
    patch stk_url(@stk), params: { stk: { amount: @stk.amount, modified_at: @stk.modified_at, phone_number: @stk.phone_number } }
    assert_redirected_to stk_url(@stk)
  end

  test "should destroy stk" do
    assert_difference("Stk.count", -1) do
      delete stk_url(@stk)
    end

    assert_redirected_to stks_url
  end
end
