class JmpaymentsController < ApplicationController
  require 'pdf-reader'
  

  before_action :set_jmcustomer, only: [:new, :create, :destroy]
  before_action :set_jmpayment, only: [:edit, :update, :show, :destroy]

  # -------------------------
  # IMPORT PAGE
  # -------------------------
  def import
  end

  def edit

  end


    # PATCH/PUT /jmcustomers/:jmcustomer_id/jmpayments/:id
  def update
    if @jmpayment.update(jmpayment_params)
      redirect_to jmcustomerpayments_index_path, notice: "Payment updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

    def search
    query = params[:q]

    @jmpayments = if query.present?
      Jmpayment.where(
        "mpesa_code ILIKE :q OR name ILIKE :q OR mpesa_number ILIKE :q OR transaction_ref ILIKE :q",
        q: "%#{query}%"
      ).order(date: :desc)
    else
      Jmpayment.none
    end
  end

  # -------------------------
# -------------------------
# UPLOAD PDF / EXCEL
# -------------------------
# IMPORT PDF / EXCEL
# -------------------------
def import_pdf

    Rails.logger.debug "🔥🔥🔥 IMPORT ACTION HIT"
  Rails.logger.debug params.inspect

  file = params[:file]

  Rails.logger.debug "FILE: #{file&.original_filename}"
  Rails.logger.debug "TYPE: #{file&.content_type}"
  file = params[:file]

  return redirect_to(jmcustomerpayments_path,
                     alert: "Please select a file.") if file.blank?

  extension = File.extname(file.original_filename).downcase
  filename  = "#{SecureRandom.hex}#{extension}"
  path      = Rails.root.join("tmp", filename)

  begin
    File.open(path, "wb") do |f|
      f.write(file.read)
    end

    rows =
      case extension
      when ".pdf"
        # KEEP EXISTING PDF LOGIC UNCHANGED
        text = read_pdf(path)

        Rails.logger.debug "===== PDF FULL TEXT START ====="
        Rails.logger.debug text
        Rails.logger.debug "LINE COUNT: #{text.lines.count}"
        Rails.logger.debug "===== PDF FULL TEXT END ====="

        parse_transactions(text)

      when ".xls", ".xlsx"
        Rails.logger.debug "===== EXCEL IMPORT START ====="

        parse_excel_transactions(path)

      else
        raise "Unsupported file type. Please upload PDF, XLS or XLSX."
      end

    Rails.logger.debug "ROWS FOUND: #{rows.count}"
    Rails.logger.debug rows.inspect

    result = save_payments(rows)

    session[:import_results] = result

    redirect_to jmcustomerpayments_path,
                notice: "#{rows.count} transactions processed successfully."

  rescue => e
    Rails.logger.error "IMPORT FAILED: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    redirect_to jmcustomerpayments_path,
                alert: "Failed to import file: #{e.message}"

  ensure
    File.delete(path) if File.exist?(path)
  end
end

  # -------------------------
  # RESULTS PAGE
  # -------------------------
  def import_results
    @results = session[:import_results]
    session[:import_results] = nil
  end

  # -------------------------
  # CRUD
  # -------------------------
  def new
    @jmpayment = @jmcustomer.jmpayments.new
  end

  def create
    @jmpayment = @jmcustomer.jmpayments.new(jmpayment_params)

    if @jmpayment.save
      redirect_to @jmcustomer, notice: "Payment added successfully"
    else
      render :new
    end
  end

  def destroy
    @jmpayment = @jmcustomer.jmpayments.find(params[:id])
    @jmpayment.destroy
    redirect_to @jmcustomer, notice: "Payment deleted"
  end

  # -------------------------
# -------------------------
# READ PDF / EXCEL
# -------------------------
def read_file(path)
  extension = File.extname(path).downcase

  case extension
  when ".pdf"
    read_pdf(path)
  when ".xls", ".xlsx"
    read_excel(path)
  else
    raise "Unsupported file type: #{extension}"
  end
end

# -------------------------
# PDF READ
# -------------------------
def read_pdf(path)
  text = ""

  PDF::Reader.open(path) do |reader|
    reader.pages.each do |page|
      text << page.text
      text << "\n"
    end
  end

  text
end

# -------------------------
# EXCEL READ
# -------------------------
def read_excel(path)
  text = ""

  workbook = Roo::Spreadsheet.open(path)

  workbook.sheets.each do |sheet|
    workbook.default_sheet = sheet

    workbook.each_row_streaming(pad_cells: true) do |row|
      values = row.map { |cell| cell&.value.to_s.strip }
      text << values.join(" ")
      text << "\n"
    end
  end

  text
end

  # -------------------------
  # PARSE LOGIC
  # -------------------------
  def parse_transactions(text)
    lines = text.split("\n").map(&:strip)

    transactions = []
    buffer = []

    lines.each do |line|
      next if line.blank?

      if line.match?(/\d{2}\/\d{2}\/\d{4}/) && line.match?(/FT\d+/)
        transactions << buffer.join(" ") if buffer.any?
        buffer = [line]
      elsif buffer.any?
        buffer << line
      end
    end

    transactions << buffer.join(" ") if buffer.any?

    transactions.map { |t| extract_transaction(t) }.compact
  end

  def extract_transaction(text)
    date  = text.match(/\d{2}\/\d{2}\/\d{4}/)&.to_s
    ref   = text.match(/FT\w+/)&.to_s
    phone = text.match(/254\d{9}/)&.to_s

    amounts = text.scan(/\d{1,3}(?:,\d{3})*\.\d{2}/)

    amount =
      if amounts.size >= 2
        amounts[-2]
      else
        amounts.last
      end

    amount = amount&.delete(",")&.to_f

    return nil if ref.blank? || amount.blank?

    {
      date: date,
      ref: ref,
      phone: phone,
      amount: amount,
      raw: text
    }
  end


def parse_excel_transactions(path)
  Rails.logger.debug "===== EXCEL IMPORT START ====="

  spreadsheet = Roo::Spreadsheet.open(path.to_s)

  Rails.logger.debug "SHEETS: #{spreadsheet.sheets.inspect}"

  spreadsheet.sheets.each do |sheet_name|
    debug_sheet = spreadsheet.sheet(sheet_name)

    Rails.logger.debug "===== SHEET: #{sheet_name} ====="

    (1..10).each do |i|
      Rails.logger.debug "ROW #{i}: #{debug_sheet.row(i).inspect}"
    end
  end

  # Actual worksheet
  sheet = spreadsheet.sheet(0)

  # Your statement headers are on row 6
  header_row = 6

  headers = sheet.row(header_row).map do |h|
    h.to_s.strip
  end

  Rails.logger.debug "HEADERS: #{headers.inspect}"

  results = []

  ((header_row + 1)..sheet.last_row).each do |i|
    values = sheet.row(i)

    next if values.compact.empty?

    row = headers.zip(values).to_h

    narration = row["Narration"].to_s.strip

    # Skip opening / closing balances
    next if narration.match?(/Opening Balance/i)
    next if narration.match?(/Closing Balance/i)

    credit = row["Credit"].to_s.gsub(",", "").strip

    # Ignore debit rows
    next if credit.blank?

    amount = credit.to_f

    next if amount <= 0

    reference = row["Reference"].to_s.strip

    phone = extract_excel_phone(narration)

    results << {
      date: row["Date"],
      ref: reference,
      phone: phone,
      amount: amount,
      raw: narration
    }
  end

  Rails.logger.debug "EXCEL RESULTS: #{results.inspect}"

  results
end


def extract_excel_phone(text)
  text = text.to_s

  if (match = text.match(/254\d{9}/))
    return "0#{match.to_s[3..]}"
  end

  if (match = text.match(/0\d{9}/))
    return match.to_s
  end

  nil
end

  # -------------------------
  # HELPERS
  # -------------------------
def normalize_text(text)
  text.to_s
      .gsub(/\r/, "")
      .gsub(/\n+/, " ")
      .gsub(/\s+/, " ")
end


def extract_name(text)
  clean = normalize_text(text)

  match = normalize_text(text).match(/201088\s+([A-Z][A-Z\s]+)/i)

if match
  return clean_name(match[1])
end

  # ✅ 1. PRIMARY (your original - most accurate)
  match = clean.match(/\|\d{12}\s+([A-Z]+(?:\s[A-Z]+){1,3})\|MPESA/)
  return clean_name(match.captures.first) if match

  # ✅ 2. SECONDARY: allow broken "MPESA"
  match = clean.match(/\|\d{12}\s+([A-Z]+(?:\s[A-Z]+){1,3})\s*\|?\s*MPES?A/i)
  return clean_name(match.captures.first) if match

  # ✅ 3. FIX SPLIT TEXT (critical)
  compact = text.to_s.gsub(/\s+/, " ")
  match = compact.match(/\d{12}\s+([A-Z]+(?:\s[A-Z]+){1,4})/)
  return clean_name(match.captures.first) if match

  # ✅ 4. FALLBACK: extract best uppercase name in text
  candidates = clean.scan(/\b[A-Z]{3,}(?:\s+[A-Z]{3,}){1,3}\b/)

  candidates = candidates.reject do |c|
    c.match?(/\b(PAY|BILL|MPESA|FROM|ACC|DATE|FT)\b/i)
  end

  return clean_name(candidates.last) if candidates.any?

  # ✅ 5. LAST RESORT (never blank)
  "Walk-in Customer"
end

def clean_name(name)
  return nil unless name

  name = name.gsub(/\b(PAY|BILL|MPESA)\b/i, "")
             .gsub(/\s+/, " ")
             .strip

  name.present? ? name : nil
end

  def normalize_phone(phone)
    phone = phone.to_s.strip

    if phone.start_with?("254")
      "0" + phone[3..-1]
    else
      phone
    end
  end
  
def parse_date(date)
  return nil if date.blank?
  return date.to_date if date.respond_to?(:to_date)

  value = date.to_s.strip

  ["%d-%m-%Y", "%d/%m/%Y"].each do |format|
    begin
      return Date.strptime(value, format)
    rescue ArgumentError
      next
    end
  end

  Rails.logger.error "DATE PARSE ERROR: #{value}"
  Date.today
end

def extract_mpesa_code(text)
  clean = normalize_text(text)

  match = normalize_text(text).match(/Acct\s+([A-Z0-9]{10})/i)

return match[1] if match

  # ✅ 1. PRIMARY: after pipe
  match = clean.match(/\|\s*([A-Z0-9]{10})\b/)
  return match.captures.first if match

  # ✅ 2. SECONDARY: before pipe
  match = clean.match(/\b([A-Z0-9]{10})\s*\|/)
  return match.captures.first if match

  # ✅ 3. FIX SPLIT CODES (critical)
  compact = text.to_s.gsub(/\s+/, "") # remove ALL spaces/newlines
  match = compact.match(/[A-Z0-9]{10}/)
  if match
    code = match.to_s
    return code if valid_mpesa_code?(code)
  end

  # ✅ 4. FALLBACK: scan normally
  candidates = clean.scan(/\b[A-Z0-9]{10}\b/)

  candidates = candidates.select { |c| valid_mpesa_code?(c) }

  # prefer realistic ones
  preferred = candidates.find { |c| c.match?(/^[UQ][A-Z0-9]{9}$/) }
  return preferred if preferred

  return candidates.last if candidates.any?

  nil
end

def valid_mpesa_code?(code)
  return false unless code.match?(/^[A-Z0-9]{10}$/)

  return false if code.start_with?("FT")
  return false if code.start_with?("KES")
  return false if code.match?(/^\d+$/)

  true
end



def save_payments(rows)
  results = { saved: 0, duplicates: 0, failed: 0, total: rows.size }

  rows.each do |row|
    begin
      phone = normalize_phone(row[:phone])
      next if phone.blank?

      # =========================
      # CUSTOMER UPSERT
      # =========================
      customer = Jmcustomer.find_or_initialize_by(phone: phone)

     customer.assign_attributes(
  location: customer.location.presence || "Unknown",
  imported: true
)

customer.name ||= extract_name(row[:raw]).presence || "Walk-in Customer"

    if customer.new_record?
  customer.points ||= 0
end

customer.is_importing = true
customer.save!

customer.convert_matching_lead if customer.jmlead_id.nil?
      # =========================
      # PAYMENT UPSERT
      # =========================
      ref = row[:ref].to_s.strip
      ref = nil if ref.blank?

      payment = if ref.present?
                  Jmpayment.find_or_initialize_by(transaction_ref: ref)
                else
                  Jmpayment.new
                end

      is_new_payment = payment.new_record?

      payment.assign_attributes(
        jmcustomer: customer,
        name: extract_name(row[:raw]),
        amount: row[:amount],
        date: parse_date(row[:date]),
        mpesa_number: phone,
        mpesa_code: extract_mpesa_code(row[:raw])
      )

      payment.save! if ref.present?

      results[:saved] += 1 if is_new_payment
      results[:duplicates] += 1 unless is_new_payment

      # =========================
      # FULFILLMENT (SAFE + STABLE)
      # =========================
      next if ref.blank?

      fulfillment = Jfulfillment.where(
        jmcustomer_id: customer.id,
        transaction_ref: ref
      ).first_or_initialize

      # 🔥 NEVER overwrite processed statuses
      if fulfillment.persisted? && fulfillment.status != "Pending"
        Rails.logger.info("Skipping fulfillment (already processed)")
        next
      end

      fulfillment.assign_attributes(
        name: customer.name,
        phone: customer.phone,
        location: customer.location.presence || "Unknown",
        feedback: customer.feedback,
        comments: customer.comments
      )

narration = row[:raw].to_s.gsub(/[\r\n\t]/, ' ').squish

fulfillment.items ||= "#{narration.presence || 'Imported Payment'} (Amount: KES #{'%.2f' % row[:amount].to_f})"
      fulfillment.status ||= "Pending"

      fulfillment.save!

    rescue => e
      Rails.logger.error "🔥 ERROR: #{e.message}"
      Rails.logger.error "ROW: #{row.inspect}"
      results[:failed] += 1
    end
  end

  results
end
  # -------------------------
  # SETTERS
  # -------------------------
 def set_jmcustomer
  @jmcustomer = Jmcustomer.find(params[:jmcustomer_id])
end

def normalize_ref(ref)
  ref.to_s.strip.upcase.gsub(/\s+/, "")
end

def transaction_key(row, phone)
  ref = row[:ref].to_s.strip.upcase
  ref = nil if ref.blank?

  return ref if ref.present?

  "#{phone}-#{row[:date]}-#{row[:amount]}".gsub(/\s+/, "").upcase
end

def set_jmpayment
  @jmpayment = Jmpayment.find(params[:id])
end


  def jmpayment_params
    params.require(:jmpayment).permit(:date, :transaction_ref, :amount, :name, :mpesa_code, :mpesa_number, :agent_id,
    :bales_count, :comments )
  end
end



