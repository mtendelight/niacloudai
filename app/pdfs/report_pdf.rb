class ReportPdf
  require 'prawn'
  require 'prawn/table'

  def initialize(order)
    @order = order
  end

  def number_with_delimiter(number, options = {})
    delimiter = options[:delimiter] || ','
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d{3})+(?!\d))/, "\\1#{delimiter}")
    parts.join('.')
  end

  def render
    Prawn::Document.new(page_size: [58 * 2.83465, 100 * 2.83465], margin: 5) do |pdf|
      # Header
      pdf.text "Janomax Household", size: 15, style: :bold, align: :center
      pdf.move_down 5

      pdf.text "Official Receipt", size: 12, style: :bold, align: :center
      pdf.move_down 5

      # Combined Served By Line
      pdf.text "Served by: #{@order.user.username}", size: 12, align: :center
      pdf.move_down 10

      # Order Information
      pdf.text "Order ID: ##{@order.orderid}", size: 12, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "Date: #{@order.created_at.strftime('%D %T')}", size: 12, align: :center
      pdf.move_down 10

      # Items Ordered Table
      pdf.text "Items Ordered:", size: 12, style: :bold
      pdf.move_down 5

      # Prepare data for the table
      items_data = [["Item Name", "Qty", "Unit Price", "Sub total"]] # Table headers

      total_quantity = 0
      total_price = 0

      # Group the order items by menu_item_id and sum their quantities and subtotals
      grouped_items = @order.order_items.group_by { |item| item.menu_item_id }

      grouped_items.each do |menu_item_id, items|
        menu_item = items.first.menu_item  # Assuming all items in the group have the same menu_item
        total_qty = items.sum { |item| item.quantity }
        subtotal = total_qty * menu_item.price

        unit_price = menu_item.price.to_i == menu_item.price ? menu_item.price.to_i : menu_item.price
        subtotal_display = subtotal.to_i == subtotal ? subtotal.to_i : subtotal

        items_data << [menu_item.name, total_qty, unit_price, subtotal_display]
        total_quantity += total_qty
        total_price += subtotal
      end

      # Add the total row
      items_data << ["Total", total_quantity, "", total_price.to_i == total_price ? total_price.to_i : total_price]

      # Draw the table
      pdf.table(items_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        self.header = true
        self.row_colors = ["F0F0F0", "FFFFFF"] # Alternating row colors
        self.cell_style = { borders: [:bottom], padding: 2 }
      end

      pdf.move_down 10

      # Calculate VAT (16% of total price)
      vat = total_price * 0.16
      grand_total = total_price

      # VAT Amount
      pdf.text "VAT (16%)", size: 10, align: :center
      pdf.text "KES #{number_with_delimiter(format('%.1f', vat), delimiter: ',')}", size: 10, align: :center,style: :bold
      pdf.move_down 5

      # Total Amount (always keeping one decimal place, even for whole numbers)
      pdf.text "Total Amount (Incl. VAT)", size: 12, style: :normal, align: :center
      pdf.move_down 5
      pdf.text "KES #{number_with_delimiter(format('%.1f', grand_total), delimiter: ',')}", size: 12, style: :bold, align: :center

      pdf.move_down 10

      # Additional Information
      pdf.text "Till Number:", size: 12, align: :center
      pdf.text "5151085", size: 12, style: :bold, align: :center
      pdf.move_down 10

      # Footer
      pdf.text "Thank you for dining with us!", size: 12, align: :center
    end.render
  end
end
