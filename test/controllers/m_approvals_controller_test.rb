require "test_helper"

class MApprovalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_approval = m_approvals(:one)
  end

  test "should get index" do
    get m_approvals_url
    assert_response :success
  end

  test "should get new" do
    get new_m_approval_url
    assert_response :success
  end

  test "should create m_approval" do
    assert_difference("MApproval.count") do
      post m_approvals_url, params: { m_approval: { approvable_id: @m_approval.approvable_id, approvable_type: @m_approval.approvable_type, approved_at: @m_approval.approved_at, approved_by: @m_approval.approved_by, comments: @m_approval.comments, status: @m_approval.status } }
    end

    assert_redirected_to m_approval_url(MApproval.last)
  end

  test "should show m_approval" do
    get m_approval_url(@m_approval)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_approval_url(@m_approval)
    assert_response :success
  end

  test "should update m_approval" do
    patch m_approval_url(@m_approval), params: { m_approval: { approvable_id: @m_approval.approvable_id, approvable_type: @m_approval.approvable_type, approved_at: @m_approval.approved_at, approved_by: @m_approval.approved_by, comments: @m_approval.comments, status: @m_approval.status } }
    assert_redirected_to m_approval_url(@m_approval)
  end

  test "should destroy m_approval" do
    assert_difference("MApproval.count", -1) do
      delete m_approval_url(@m_approval)
    end

    assert_redirected_to m_approvals_url
  end
end
