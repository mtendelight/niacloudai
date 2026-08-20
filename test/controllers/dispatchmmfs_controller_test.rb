require "test_helper"

class DispatchmmfsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dispatchmmf = dispatchmmfs(:one)
  end

  test "should get index" do
    get dispatchmmfs_url
    assert_response :success
  end

  test "should get new" do
    get new_dispatchmmf_url
    assert_response :success
  end

  test "should create dispatchmmf" do
    assert_difference("Dispatchmmf.count") do
      post dispatchmmfs_url, params: { dispatchmmf: { id_number: @dispatchmmf.id_number, interest: @dispatchmmf.interest, name: @dispatchmmf.name, period: @dispatchmmf.period, phone: @dispatchmmf.phone, principal: @dispatchmmf.principal, status: @dispatchmmf.status, total_amount: @dispatchmmf.total_amount } }
    end

    assert_redirected_to dispatchmmf_url(Dispatchmmf.last)
  end

  test "should show dispatchmmf" do
    get dispatchmmf_url(@dispatchmmf)
    assert_response :success
  end

  test "should get edit" do
    get edit_dispatchmmf_url(@dispatchmmf)
    assert_response :success
  end

  test "should update dispatchmmf" do
    patch dispatchmmf_url(@dispatchmmf), params: { dispatchmmf: { id_number: @dispatchmmf.id_number, interest: @dispatchmmf.interest, name: @dispatchmmf.name, period: @dispatchmmf.period, phone: @dispatchmmf.phone, principal: @dispatchmmf.principal, status: @dispatchmmf.status, total_amount: @dispatchmmf.total_amount } }
    assert_redirected_to dispatchmmf_url(@dispatchmmf)
  end

  test "should destroy dispatchmmf" do
    assert_difference("Dispatchmmf.count", -1) do
      delete dispatchmmf_url(@dispatchmmf)
    end

    assert_redirected_to dispatchmmfs_url
  end
end
