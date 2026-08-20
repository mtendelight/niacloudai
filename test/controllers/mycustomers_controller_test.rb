require "test_helper"

class MycustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mycustomer = mycustomers(:one)
  end

  test "should get index" do
    get mycustomers_url
    assert_response :success
  end

  test "should get new" do
    get new_mycustomer_url
    assert_response :success
  end

  test "should create mycustomer" do
    assert_difference("Mycustomer.count") do
      post mycustomers_url, params: { mycustomer: { email: @mycustomer.email, fullname: @mycustomer.fullname, phone_number: @mycustomer.phone_number } }
    end

    assert_redirected_to mycustomer_url(Mycustomer.last)
  end

  test "should show mycustomer" do
    get mycustomer_url(@mycustomer)
    assert_response :success
  end

  test "should get edit" do
    get edit_mycustomer_url(@mycustomer)
    assert_response :success
  end

  test "should update mycustomer" do
    patch mycustomer_url(@mycustomer), params: { mycustomer: { email: @mycustomer.email, fullname: @mycustomer.fullname, phone_number: @mycustomer.phone_number } }
    assert_redirected_to mycustomer_url(@mycustomer)
  end

  test "should destroy mycustomer" do
    assert_difference("Mycustomer.count", -1) do
      delete mycustomer_url(@mycustomer)
    end

    assert_redirected_to mycustomers_url
  end
end
