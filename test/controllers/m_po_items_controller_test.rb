require "test_helper"

class MPoItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_po_item = m_po_items(:one)
  end

  test "should get index" do
    get m_po_items_url
    assert_response :success
  end

  test "should get new" do
    get new_m_po_item_url
    assert_response :success
  end

  test "should create m_po_item" do
    assert_difference("MPoItem.count") do
      post m_po_items_url, params: { m_po_item: { amount: @m_po_item.amount, description: @m_po_item.description, m_po_id: @m_po_item.m_po_id, no: @m_po_item.no, quantity: @m_po_item.quantity, unit_price: @m_po_item.unit_price, uom: @m_po_item.uom } }
    end

    assert_redirected_to m_po_item_url(MPoItem.last)
  end

  test "should show m_po_item" do
    get m_po_item_url(@m_po_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_po_item_url(@m_po_item)
    assert_response :success
  end

  test "should update m_po_item" do
    patch m_po_item_url(@m_po_item), params: { m_po_item: { amount: @m_po_item.amount, description: @m_po_item.description, m_po_id: @m_po_item.m_po_id, no: @m_po_item.no, quantity: @m_po_item.quantity, unit_price: @m_po_item.unit_price, uom: @m_po_item.uom } }
    assert_redirected_to m_po_item_url(@m_po_item)
  end

  test "should destroy m_po_item" do
    assert_difference("MPoItem.count", -1) do
      delete m_po_item_url(@m_po_item)
    end

    assert_redirected_to m_po_items_url
  end
end
