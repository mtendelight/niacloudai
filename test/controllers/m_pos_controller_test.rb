require "test_helper"

class MPosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_po = m_pos(:one)
  end

  test "should get index" do
    get m_pos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_po_url
    assert_response :success
  end

  test "should create m_po" do
    assert_difference("MPo.count") do
      post m_pos_url, params: { m_po: { date: @m_po.date, m_subcontractor_id: @m_po.m_subcontractor_id, po_number: @m_po.po_number, status: @m_po.status, total_amount: @m_po.total_amount } }
    end

    assert_redirected_to m_po_url(MPo.last)
  end

  test "should show m_po" do
    get m_po_url(@m_po)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_po_url(@m_po)
    assert_response :success
  end

  test "should update m_po" do
    patch m_po_url(@m_po), params: { m_po: { date: @m_po.date, m_subcontractor_id: @m_po.m_subcontractor_id, po_number: @m_po.po_number, status: @m_po.status, total_amount: @m_po.total_amount } }
    assert_redirected_to m_po_url(@m_po)
  end

  test "should destroy m_po" do
    assert_difference("MPo.count", -1) do
      delete m_po_url(@m_po)
    end

    assert_redirected_to m_pos_url
  end
end
