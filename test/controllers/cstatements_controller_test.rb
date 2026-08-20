require "test_helper"

class CstatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cstatement = cstatements(:one)
  end

  test "should get index" do
    get cstatements_url
    assert_response :success
  end

  test "should get new" do
    get new_cstatement_url
    assert_response :success
  end

  test "should create cstatement" do
    assert_difference("Cstatement.count") do
      post cstatements_url, params: { cstatement: { balance: @cstatement.balance, contractor_id: @cstatement.contractor_id, from_date: @cstatement.from_date, to_date: @cstatement.to_date, total_invoiced: @cstatement.total_invoiced, total_paid: @cstatement.total_paid } }
    end

    assert_redirected_to cstatement_url(Cstatement.last)
  end

  test "should show cstatement" do
    get cstatement_url(@cstatement)
    assert_response :success
  end

  test "should get edit" do
    get edit_cstatement_url(@cstatement)
    assert_response :success
  end

  test "should update cstatement" do
    patch cstatement_url(@cstatement), params: { cstatement: { balance: @cstatement.balance, contractor_id: @cstatement.contractor_id, from_date: @cstatement.from_date, to_date: @cstatement.to_date, total_invoiced: @cstatement.total_invoiced, total_paid: @cstatement.total_paid } }
    assert_redirected_to cstatement_url(@cstatement)
  end

  test "should destroy cstatement" do
    assert_difference("Cstatement.count", -1) do
      delete cstatement_url(@cstatement)
    end

    assert_redirected_to cstatements_url
  end
end
