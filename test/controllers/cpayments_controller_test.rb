require "test_helper"

class CpaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cpayment = cpayments(:one)
  end

  test "should get index" do
    get cpayments_url
    assert_response :success
  end

  test "should get new" do
    get new_cpayment_url
    assert_response :success
  end

  test "should create cpayment" do
    assert_difference("Cpayment.count") do
      post cpayments_url, params: { cpayment: { amount: @cpayment.amount, cinvoice_id: @cpayment.cinvoice_id, method: @cpayment.method, notes: @cpayment.notes, payment_date: @cpayment.payment_date, reference: @cpayment.reference } }
    end

    assert_redirected_to cpayment_url(Cpayment.last)
  end

  test "should show cpayment" do
    get cpayment_url(@cpayment)
    assert_response :success
  end

  test "should get edit" do
    get edit_cpayment_url(@cpayment)
    assert_response :success
  end

  test "should update cpayment" do
    patch cpayment_url(@cpayment), params: { cpayment: { amount: @cpayment.amount, cinvoice_id: @cpayment.cinvoice_id, method: @cpayment.method, notes: @cpayment.notes, payment_date: @cpayment.payment_date, reference: @cpayment.reference } }
    assert_redirected_to cpayment_url(@cpayment)
  end

  test "should destroy cpayment" do
    assert_difference("Cpayment.count", -1) do
      delete cpayment_url(@cpayment)
    end

    assert_redirected_to cpayments_url
  end
end
