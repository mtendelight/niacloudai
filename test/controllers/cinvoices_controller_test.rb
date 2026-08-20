require "test_helper"

class CinvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cinvoice = cinvoices(:one)
  end

  test "should get index" do
    get cinvoices_url
    assert_response :success
  end

  test "should get new" do
    get new_cinvoice_url
    assert_response :success
  end

  test "should create cinvoice" do
    assert_difference("Cinvoice.count") do
      post cinvoices_url, params: { cinvoice: { amount: @cinvoice.amount, contractor_id: @cinvoice.contractor_id, description: @cinvoice.description, due_date: @cinvoice.due_date, invoice_number: @cinvoice.invoice_number, issue_date: @cinvoice.issue_date, status: @cinvoice.status } }
    end

    assert_redirected_to cinvoice_url(Cinvoice.last)
  end

  test "should show cinvoice" do
    get cinvoice_url(@cinvoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_cinvoice_url(@cinvoice)
    assert_response :success
  end

  test "should update cinvoice" do
    patch cinvoice_url(@cinvoice), params: { cinvoice: { amount: @cinvoice.amount, contractor_id: @cinvoice.contractor_id, description: @cinvoice.description, due_date: @cinvoice.due_date, invoice_number: @cinvoice.invoice_number, issue_date: @cinvoice.issue_date, status: @cinvoice.status } }
    assert_redirected_to cinvoice_url(@cinvoice)
  end

  test "should destroy cinvoice" do
    assert_difference("Cinvoice.count", -1) do
      delete cinvoice_url(@cinvoice)
    end

    assert_redirected_to cinvoices_url
  end
end
