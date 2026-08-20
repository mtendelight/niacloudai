class InvoicePdf
  require 'prawn'
  require 'prawn/table'
  require 'axlsx' # Require axlsx for Excel export

  def initialize(customer)
    @customer = customer
    @quantity = @customer.quantity # Default quantity if not provided
  end

  def number_with_delimiter(number, options = {})
    delimiter = options[:delimiter] || ','
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d{3})+(?!\d))/, "\\1#{delimiter}")
    parts.join('.')
  end

  # Method to calculate total
  def calculate_total
    @customer.payment_amount * @quantity
  end

  # Method to generate PDF
  def render
    Prawn::Document.new(page_size: 'A4', margin: 30) do |pdf|
      # Custom Header with Image between Nia and Chef
      pdf.font_size(20) do
        pdf.text_box "Nia", at: [200, pdf.cursor], width: 50, style: :bold
        logo_path = Rails.root.join("app/assets/images/flogo.png")
        pdf.image logo_path, width: 50, height: 50, at: [230, pdf.cursor + 20]
        pdf.text_box "POS", at: [275, pdf.cursor], width: 100, style: :bold
      end
      pdf.move_down 60

      # Continue with the rest of the invoice
      pdf.text "Official Invoice", size: 15, style: :bold, align: :center
      pdf.move_down 20

      # Customer Information
      pdf.text "Invoice for:", size: 12, style: :bold
      pdf.text "Name: #{@customer.name}", size: 10
      pdf.text "Phone: #{@customer.phone}", size: 10
      pdf.text "Alternative Phone: #{@customer.alternative_phone}", size: 10
      pdf.text "Email: #{@customer.email}", size: 10
      pdf.move_down 10

      # Invoice Information
      pdf.text "Payment Details:", size: 12, style: :bold
      pdf.text "Payment Duration: #{@customer.payment_duration}", size: 10
      pdf.text "Payment Date: #{@customer.payment_date.strftime('%B %d, %Y')}", size: 10
      pdf.text "Payment Amount: KES #{number_with_delimiter(@customer.payment_amount, delimiter: ',')}", size: 10
      pdf.move_down 15

      # Order Information
      current_date = Date.today.strftime('%Y%m%d')
      order_id = "#{current_date}-#{@customer.id}"

      pdf.text "Order ID: ##{order_id}", size: 12, style: :bold, align: :left
      pdf.text "Date: #{@customer.created_at.strftime('%B %d, %Y %T')}", size: 12, align: :left
      pdf.move_down 10

      # Items Ordered Table
      pdf.text "Items Ordered:", size: 12, style: :bold
      pdf.move_down 5

      # Table Data
      invoice_table_data = [
        ["Payment Amount", "Quantity", "Total"],
        ["KES #{number_with_delimiter(@customer.payment_amount, delimiter: ',')}", @quantity, "KES #{number_with_delimiter(calculate_total, delimiter: ',')}"]
      ]

      pdf.table(invoice_table_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        self.header = true
        self.cell_style = { borders: [:bottom], padding: 5 }
        self.row_colors = ["F0F0F0", "FFFFFF"]
      end

      pdf.move_down 15

      # Payment Information
      pdf.text "Payment Method: Mpesa", size: 12, align: :center
      pdf.text "Till Number: 5151085", size: 12, style: :bold, align: :center
      pdf.move_down 20

      # Footer
      pdf.text "Thank you for your business!", size: 12, align: :center
    end.render
  end
end
