class CinvoicePdf < Prawn::Document

  def initialize(invoice)
    super(page_size: "A4", margin: 40)

    @invoice = invoice
    @contractor = invoice.contractor

    header
    contractor_info
    invoice_info
    line_items_table
    totals_section
    signatories
    footer
  end

  def signature_block(title)
  [
    "",
    "______________________________",
    title
  ].join("\n")
end

  # ================= HEADER =================
def header
  if Rails.root.join("app/assets/images/logo.png").exist?
    image Rails.root.join("app/assets/images/logo.png"), width: 100
  end

  move_up 50
  bounding_box([150, cursor + 40], width: 400) do
    text "Momak Technologies Ltd", size: 18, style: :bold
    text "Al Bustani, Kilimani"
    text "Contact: 0111555749"
  end

  move_down 40
  stroke_horizontal_rule
  move_down 15

  text "INVOICE", size: 22, style: :bold, align: :center
  move_down 10
end

  # ================= CONTRACTOR =================
  def contractor_info
    text "Bill To:", style: :bold
    text @contractor.name
    text @contractor.location
    text @contractor.phone
    move_down 15
  end

  # ================= INVOICE INFO =================
  def invoice_info
    data = [
      ["Invoice #", @invoice.invoice_number],
      ["Issue Date", @invoice.issue_date],
      ["Due Date", @invoice.due_date],
      ["Status", @invoice.status]
    ]

    table(data, cell_style: { borders: [] })

    move_down 15
  end

  # ================= LINE ITEMS =================
  def line_items_table
    move_down 10

    data = [["Description", "Qty", "Unit Price", "Total"]]

    @invoice.cinvoice_items.each do |item|
      data << [
        item.description,
        item.quantity,
        format_currency(item.unit_price),
        format_currency(line_total(item))
      ]
    end

    table(data, header: true, width: bounds.width) do
      row(0).font_style = :bold
      row(0).background_color = "EEEEEE"
      self.row_colors = ["FFFFFF", "F9F9F9"]
    end

    move_down 15
  end

  # ================= TOTALS =================
  def totals_section
    subtotal = calculate_subtotal
    paid = @invoice.paid_total.to_f
    balance = subtotal - paid

    data = [
      ["Subtotal", format_currency(subtotal)],
      ["Paid", format_currency(paid)],
      ["Balance", format_currency(balance)]
    ]

    table(data, position: :right, cell_style: { borders: [] }) do
      columns(0).font_style = :bold
    end
  end

  # ================= FOOTER =================
  def footer
    move_down 30
    text "Thank you for your business.", align: :center, size: 10
  end

  # ================= HELPERS =================
  def line_total(item)
    item.quantity.to_f * item.unit_price.to_f
  end

  def calculate_subtotal
    @invoice.cinvoice_items.sum do |item|
      line_total(item)
    end
  end

  def format_currency(amount)
    "KES #{'%.2f' % amount}"
  end

  # ================= SIGNATORIES =================
def signatories
  move_down 50

  text "Signatories", style: :bold
  move_down 20

  table([
    [
      signature_block("Momak Representative"),
      signature_block("Contractor Representative")
    ]
  ], cell_style: { borders: [] }, width: bounds.width)
end

end