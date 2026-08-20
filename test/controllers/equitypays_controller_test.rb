require "test_helper"

class EquitypaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equitypay = equitypays(:one)
  end

  test "should get index" do
    get equitypays_url
    assert_response :success
  end

  test "should get new" do
    get new_equitypay_url
    assert_response :success
  end

  test "should create equitypay" do
    assert_difference("Equitypay.count") do
      post equitypays_url, params: { equitypay: { bill_amount: @equitypay.bill_amount, bill_currency: @equitypay.bill_currency, bill_reference: @equitypay.bill_reference, payer_account: @equitypay.payer_account, payer_name: @equitypay.payer_name } }
    end

    assert_redirected_to equitypay_url(Equitypay.last)
  end

  test "should show equitypay" do
    get equitypay_url(@equitypay)
    assert_response :success
  end

  test "should get edit" do
    get edit_equitypay_url(@equitypay)
    assert_response :success
  end

  test "should update equitypay" do
    patch equitypay_url(@equitypay), params: { equitypay: { bill_amount: @equitypay.bill_amount, bill_currency: @equitypay.bill_currency, bill_reference: @equitypay.bill_reference, payer_account: @equitypay.payer_account, payer_name: @equitypay.payer_name } }
    assert_redirected_to equitypay_url(@equitypay)
  end

  test "should destroy equitypay" do
    assert_difference("Equitypay.count", -1) do
      delete equitypay_url(@equitypay)
    end

    assert_redirected_to equitypays_url
  end
end
