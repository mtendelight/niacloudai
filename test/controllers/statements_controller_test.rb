require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @statement = statements(:one)
  end

  test "should get index" do
    get statements_url
    assert_response :success
  end

  test "should get new" do
    get new_statement_url
    assert_response :success
  end

  test "should create statement" do
    assert_difference("Statement.count") do
      post statements_url, params: { statement: { client_id: @statement.client_id, end_date: @statement.end_date, start_date: @statement.start_date, statement_number: @statement.statement_number, total_amount_due: @statement.total_amount_due } }
    end

    assert_redirected_to statement_url(Statement.last)
  end

  test "should show statement" do
    get statement_url(@statement)
    assert_response :success
  end

  test "should get edit" do
    get edit_statement_url(@statement)
    assert_response :success
  end

  test "should update statement" do
    patch statement_url(@statement), params: { statement: { client_id: @statement.client_id, end_date: @statement.end_date, start_date: @statement.start_date, statement_number: @statement.statement_number, total_amount_due: @statement.total_amount_due } }
    assert_redirected_to statement_url(@statement)
  end

  test "should destroy statement" do
    assert_difference("Statement.count", -1) do
      delete statement_url(@statement)
    end

    assert_redirected_to statements_url
  end
end
