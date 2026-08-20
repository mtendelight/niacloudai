require "test_helper"

class MInvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_invoice = m_invoices(:one)
  end

  test "should get index" do
    get m_invoices_url
    assert_response :success
  end

  test "should get new" do
    get new_m_invoice_url
    assert_response :success
  end

  test "should create m_invoice" do
    assert_difference("MInvoice.count") do
      post m_invoices_url, params: { m_invoice: { date: @m_invoice.date, invoice_number: @m_invoice.invoice_number, m_po_id: @m_invoice.m_po_id, m_subcontractor_id: @m_invoice.m_subcontractor_id, status: @m_invoice.status, total_amount: @m_invoice.total_amount } }
    end

    assert_redirected_to m_invoice_url(MInvoice.last)
  end

  test "should show m_invoice" do
    get m_invoice_url(@m_invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_invoice_url(@m_invoice)
    assert_response :success
  end

  test "should update m_invoice" do
    patch m_invoice_url(@m_invoice), params: { m_invoice: { date: @m_invoice.date, invoice_number: @m_invoice.invoice_number, m_po_id: @m_invoice.m_po_id, m_subcontractor_id: @m_invoice.m_subcontractor_id, status: @m_invoice.status, total_amount: @m_invoice.total_amount } }
    assert_redirected_to m_invoice_url(@m_invoice)
  end

  test "should destroy m_invoice" do
    assert_difference("MInvoice.count", -1) do
      delete m_invoice_url(@m_invoice)
    end

    assert_redirected_to m_invoices_url
  end
end
