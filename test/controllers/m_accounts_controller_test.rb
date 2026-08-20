require "test_helper"

class MAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_account = m_accounts(:one)
  end

  test "should get index" do
    get m_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_m_account_url
    assert_response :success
  end

  test "should create m_account" do
    assert_difference("MAccount.count") do
      post m_accounts_url, params: { m_account: { account_type: @m_account.account_type, balance: @m_account.balance, name: @m_account.name } }
    end

    assert_redirected_to m_account_url(MAccount.last)
  end

  test "should show m_account" do
    get m_account_url(@m_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_account_url(@m_account)
    assert_response :success
  end

  test "should update m_account" do
    patch m_account_url(@m_account), params: { m_account: { account_type: @m_account.account_type, balance: @m_account.balance, name: @m_account.name } }
    assert_redirected_to m_account_url(@m_account)
  end

  test "should destroy m_account" do
    assert_difference("MAccount.count", -1) do
      delete m_account_url(@m_account)
    end

    assert_redirected_to m_accounts_url
  end
end
