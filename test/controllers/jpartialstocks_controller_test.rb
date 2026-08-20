require "test_helper"

class JpartialstocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jpartialstock = jpartialstocks(:one)
  end

  test "should get index" do
    get jpartialstocks_url
    assert_response :success
  end

  test "should get new" do
    get new_jpartialstock_url
    assert_response :success
  end

  test "should create jpartialstock" do
    assert_difference("Jpartialstock.count") do
      post jpartialstocks_url, params: { jpartialstock: { amount: @jpartialstock.amount, bale_name: @jpartialstock.bale_name, branch: @jpartialstock.branch, jstock_id: @jpartialstock.jstock_id, note: @jpartialstock.note, qty: @jpartialstock.qty, selling_price: @jpartialstock.selling_price } }
    end

    assert_redirected_to jpartialstock_url(Jpartialstock.last)
  end

  test "should show jpartialstock" do
    get jpartialstock_url(@jpartialstock)
    assert_response :success
  end

  test "should get edit" do
    get edit_jpartialstock_url(@jpartialstock)
    assert_response :success
  end

  test "should update jpartialstock" do
    patch jpartialstock_url(@jpartialstock), params: { jpartialstock: { amount: @jpartialstock.amount, bale_name: @jpartialstock.bale_name, branch: @jpartialstock.branch, jstock_id: @jpartialstock.jstock_id, note: @jpartialstock.note, qty: @jpartialstock.qty, selling_price: @jpartialstock.selling_price } }
    assert_redirected_to jpartialstock_url(@jpartialstock)
  end

  test "should destroy jpartialstock" do
    assert_difference("Jpartialstock.count", -1) do
      delete jpartialstock_url(@jpartialstock)
    end

    assert_redirected_to jpartialstocks_url
  end
end
