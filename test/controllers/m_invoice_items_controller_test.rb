require "test_helper"

class MInvoiceItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_invoice_item = m_invoice_items(:one)
  end

  test "should get index" do
    get m_invoice_items_url
    assert_response :success
  end

  test "should get new" do
    get new_m_invoice_item_url
    assert_response :success
  end

  test "should create m_invoice_item" do
    assert_difference("MInvoiceItem.count") do
      post m_invoice_items_url, params: { m_invoice_item: { amount: @m_invoice_item.amount, description: @m_invoice_item.description, m_invoice_id: @m_invoice_item.m_invoice_id, no: @m_invoice_item.no, quantity: @m_invoice_item.quantity, unit_price: @m_invoice_item.unit_price, uom: @m_invoice_item.uom } }
    end

    assert_redirected_to m_invoice_item_url(MInvoiceItem.last)
  end

  test "should show m_invoice_item" do
    get m_invoice_item_url(@m_invoice_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_invoice_item_url(@m_invoice_item)
    assert_response :success
  end

  test "should update m_invoice_item" do
    patch m_invoice_item_url(@m_invoice_item), params: { m_invoice_item: { amount: @m_invoice_item.amount, description: @m_invoice_item.description, m_invoice_id: @m_invoice_item.m_invoice_id, no: @m_invoice_item.no, quantity: @m_invoice_item.quantity, unit_price: @m_invoice_item.unit_price, uom: @m_invoice_item.uom } }
    assert_redirected_to m_invoice_item_url(@m_invoice_item)
  end

  test "should destroy m_invoice_item" do
    assert_difference("MInvoiceItem.count", -1) do
      delete m_invoice_item_url(@m_invoice_item)
    end

    assert_redirected_to m_invoice_items_url
  end
end
