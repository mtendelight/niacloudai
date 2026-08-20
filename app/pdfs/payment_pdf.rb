class PaymentPdf
  require 'prawn'
  require 'prawn/table'
  require 'axlsx' # Required for Excel export

  def initialize(payment)
    @payment = payment
  end

  def number_with_delimiter(number, options = {})
    delimiter = options[:delimiter] || ','
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d{3})+(?!\d))/, "\\1#{delimiter}")
    parts.join('.')
  end

  def calculate_total
    @payment.amount
  end

  def render
    Prawn::Document.new(page_size: [58 * 2.83465, 100 * 2.83465], margin: 5) do |pdf|
      # Custom Header with Image between Nia and Chef
        pdf.move_down 10
      pdf.font_size(10) do
        pdf.text_box "Janomax", at: [10, pdf.cursor], width: 50, style: :bold
        logo_path = Rails.root.join("app/assets/images/flogo.png")
        pdf.image logo_path, width: 25, height: 25, at: [60, pdf.cursor + 10]
        pdf.text_box "Household", at: [90, pdf.cursor], width: 60, style: :bold
      end
      pdf.move_down 25

      # Official Invoice title
      pdf.text "Official Receipt", size: 12, style: :bold, align: :center
      pdf.move_down 5

      # Customer Information (Directly using the name from the payment)
      pdf.text "Invoice for:", size: 8, style: :bold
      pdf.text "Name: #{@payment.name || 'N/A'}", size: 7 # Directly use payment's name attribute
      pdf.move_down 3

      # Invoice Information
      pdf.text "Payment Details:", size: 8, style: :bold
      pdf.text "Payment Date: #{@payment.posted_at.strftime('%B %d, %Y')}", size: 7
      pdf.text "Payment Amount: KES #{number_with_delimiter(@payment.amount, delimiter: ',')}", size: 7
      pdf.move_down 5

      # Order Information (Including dynamic Order ID generation)
      current_date = Date.today.strftime('%Y%m%d')
      order_id = "#{current_date}-#{@payment.id}"

      pdf.text "Order ID: ##{order_id}", size: 8, style: :bold, align: :left
      pdf.text "Date: #{@payment.posted_at.strftime('%B %d, %Y %T')}", size: 7, align: :left
      pdf.move_down 5

      # Items Ordered Table (Payment-related info)
      pdf.text "Payment Breakdown:", size: 8, style: :bold
      pdf.move_down 3

      # Table Data
      invoice_table_data = [
        ["Payment Description", "Total"],
        ["Payment for Households", "KES #{number_with_delimiter(calculate_total, delimiter: ',')}"]
      ]

      pdf.table(invoice_table_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        self.header = true
        self.cell_style = { borders: [:bottom], padding: 3 }
        self.row_colors = ["F0F0F0", "FFFFFF"]
      end

      pdf.move_down 5

      # Payment Method (Dynamic information based on payment)
      pdf.text "Payment Method: Mpesa", size: 8, align: :center
      pdf.text "Till Number: 5151085", size: 8, style: :bold, align: :center
      pdf.move_down 5

      # Footer
      pdf.text "Thank you for your business!", size: 8, align: :center
    end.render
  end
end
