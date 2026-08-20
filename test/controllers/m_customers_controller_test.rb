require "test_helper"

class MCustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_customer = m_customers(:one)
  end

  test "should get index" do
    get m_customers_url
    assert_response :success
  end

  test "should get new" do
    get new_m_customer_url
    assert_response :success
  end

  test "should create m_customer" do
    assert_difference("MCustomer.count") do
      post m_customers_url, params: { m_customer: { airbnb_id: @m_customer.airbnb_id, email: @m_customer.email, name: @m_customer.name, phone: @m_customer.phone } }
    end

    assert_redirected_to m_customer_url(MCustomer.last)
  end

  test "should show m_customer" do
    get m_customer_url(@m_customer)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_customer_url(@m_customer)
    assert_response :success
  end

  test "should update m_customer" do
    patch m_customer_url(@m_customer), params: { m_customer: { airbnb_id: @m_customer.airbnb_id, email: @m_customer.email, name: @m_customer.name, phone: @m_customer.phone } }
    assert_redirected_to m_customer_url(@m_customer)
  end

  test "should destroy m_customer" do
    assert_difference("MCustomer.count", -1) do
      delete m_customer_url(@m_customer)
    end

    assert_redirected_to m_customers_url
  end
end
