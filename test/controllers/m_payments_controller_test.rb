require "test_helper"

class MPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_payment = m_payments(:one)
  end

  test "should get index" do
    get m_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_m_payment_url
    assert_response :success
  end

  test "should create m_payment" do
    assert_difference("MPayment.count") do
      post m_payments_url, params: { m_payment: { amount: @m_payment.amount, m_invoice_id: @m_payment.m_invoice_id, m_subcontractor_id: @m_payment.m_subcontractor_id, method: @m_payment.method, payment_date: @m_payment.payment_date, status: @m_payment.status } }
    end

    assert_redirected_to m_payment_url(MPayment.last)
  end

  test "should show m_payment" do
    get m_payment_url(@m_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_payment_url(@m_payment)
    assert_response :success
  end

  test "should update m_payment" do
    patch m_payment_url(@m_payment), params: { m_payment: { amount: @m_payment.amount, m_invoice_id: @m_payment.m_invoice_id, m_subcontractor_id: @m_payment.m_subcontractor_id, method: @m_payment.method, payment_date: @m_payment.payment_date, status: @m_payment.status } }
    assert_redirected_to m_payment_url(@m_payment)
  end

  test "should destroy m_payment" do
    assert_difference("MPayment.count", -1) do
      delete m_payment_url(@m_payment)
    end

    assert_redirected_to m_payments_url
  end
end
