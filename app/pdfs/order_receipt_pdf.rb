# app/pdfs/order_receipt_pdf.rb
require "prawn"
require "prawn/table"
# app/pdfs/order_receipt_pdf.rb
# app/pdfs/order_receipt_pdf.rb
class OrderReceiptPdf < Prawn::Document
  def initialize(order)
    super(page_size: [226, 600], margin: 10) # 🔥 thermal receipt width
    @order = order

    header
    customer_details
    items_table
    total_section
    footer
  end

  def header
    text "NiaComputers", size: 16, style: :bold, align: :center
    text "Sales Receipt", size: 10, align: :center
    move_down 10

    text "Order ##{@order.id}", size: 9
    text "Date: #{Time.current.strftime("%d %b %Y %H:%M")}", size: 9
    stroke_horizontal_rule
    move_down 10
  end

  def customer_details
    text "Customer:", style: :bold, size: 9
    text @order.customer_name.to_s, size: 9
    text @order.phone.to_s, size: 9
    text @order.address.to_s, size: 9
    move_down 10
  end

def items_table
  table(
    table_data,
    width: bounds.width,
    cell_style: { size: 8, padding: 2 }
  ) do
    self.header = true
    row(0).font_style = :bold
  end
end

def table_data
  [["Item", "Qty", "Total"]] +
    @order.niaorder_items.map do |item|
      [
        item.niaproduct.name.to_s[0..18],
        item.quantity,
        "KSh #{item.quantity * item.price}"
      ]
    end
end

  def total_section
    move_down 10
    stroke_horizontal_rule
    move_down 5

    text "TOTAL: KSh #{@order.total}",
         size: 12,
         style: :bold,
         align: :right
  end

  def footer
    move_down 20
    text "Thank you for shopping!", size: 8, align: :center
  end
end