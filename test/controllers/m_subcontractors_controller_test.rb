require "test_helper"

class MSubcontractorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_subcontractor = m_subcontractors(:one)
  end

  test "should get index" do
    get m_subcontractors_url
    assert_response :success
  end

  test "should get new" do
    get new_m_subcontractor_url
    assert_response :success
  end

  test "should create m_subcontractor" do
    assert_difference("MSubcontractor.count") do
      post m_subcontractors_url, params: { m_subcontractor: { contact: @m_subcontractor.contact, email: @m_subcontractor.email, name: @m_subcontractor.name } }
    end

    assert_redirected_to m_subcontractor_url(MSubcontractor.last)
  end

  test "should show m_subcontractor" do
    get m_subcontractor_url(@m_subcontractor)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_subcontractor_url(@m_subcontractor)
    assert_response :success
  end

  test "should update m_subcontractor" do
    patch m_subcontractor_url(@m_subcontractor), params: { m_subcontractor: { contact: @m_subcontractor.contact, email: @m_subcontractor.email, name: @m_subcontractor.name } }
    assert_redirected_to m_subcontractor_url(@m_subcontractor)
  end

  test "should destroy m_subcontractor" do
    assert_difference("MSubcontractor.count", -1) do
      delete m_subcontractor_url(@m_subcontractor)
    end

    assert_redirected_to m_subcontractors_url
  end
end
