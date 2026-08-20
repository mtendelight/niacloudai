require "test_helper"

class MTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_transaction = m_transactions(:one)
  end

  test "should get index" do
    get m_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_m_transaction_url
    assert_response :success
  end

  test "should create m_transaction" do
    assert_difference("MTransaction.count") do
      post m_transactions_url, params: { m_transaction: { amount: @m_transaction.amount, description: @m_transaction.description, m_account_id: @m_transaction.m_account_id, transaction_type: @m_transaction.transaction_type } }
    end

    assert_redirected_to m_transaction_url(MTransaction.last)
  end

  test "should show m_transaction" do
    get m_transaction_url(@m_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_transaction_url(@m_transaction)
    assert_response :success
  end

  test "should update m_transaction" do
    patch m_transaction_url(@m_transaction), params: { m_transaction: { amount: @m_transaction.amount, description: @m_transaction.description, m_account_id: @m_transaction.m_account_id, transaction_type: @m_transaction.transaction_type } }
    assert_redirected_to m_transaction_url(@m_transaction)
  end

  test "should destroy m_transaction" do
    assert_difference("MTransaction.count", -1) do
      delete m_transaction_url(@m_transaction)
    end

    assert_redirected_to m_transactions_url
  end
end
