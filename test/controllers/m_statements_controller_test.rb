require "test_helper"

class MStatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_statement = m_statements(:one)
  end

  test "should get index" do
    get m_statements_url
    assert_response :success
  end

  test "should get new" do
    get new_m_statement_url
    assert_response :success
  end

  test "should create m_statement" do
    assert_difference("MStatement.count") do
      post m_statements_url, params: { m_statement: { end_date: @m_statement.end_date, m_subcontractor_id: @m_statement.m_subcontractor_id, start_date: @m_statement.start_date, total_amount: @m_statement.total_amount } }
    end

    assert_redirected_to m_statement_url(MStatement.last)
  end

  test "should show m_statement" do
    get m_statement_url(@m_statement)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_statement_url(@m_statement)
    assert_response :success
  end

  test "should update m_statement" do
    patch m_statement_url(@m_statement), params: { m_statement: { end_date: @m_statement.end_date, m_subcontractor_id: @m_statement.m_subcontractor_id, start_date: @m_statement.start_date, total_amount: @m_statement.total_amount } }
    assert_redirected_to m_statement_url(@m_statement)
  end

  test "should destroy m_statement" do
    assert_difference("MStatement.count", -1) do
      delete m_statement_url(@m_statement)
    end

    assert_redirected_to m_statements_url
  end
end
