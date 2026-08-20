class Janomaxlead < ApplicationRecord
  audited

  belongs_to :jmcustomer, optional: true


  has_many :janomaxleadcalls,
           dependent: :destroy

  has_many :janomax_outbound_calls,
         dependent: :destroy

  enum :lead_status, {
    open: "open",
    converted: "converted",
    lost: "lost"
  }, suffix: true

  validates :phone, presence: true, uniqueness: true


  # app/models/janomaxlead.rb


  scope :pending_followup, lambda {

  latest_inbound = Janomaxleadcall
    .select("DISTINCT ON (janomaxlead_id)
             janomaxlead_id,
             status,
             called_at")
    .order("janomaxlead_id, called_at DESC, id DESC")

  latest_outbound = JanomaxOutboundCall
    .select("DISTINCT ON (janomaxlead_id)
             janomaxlead_id,
             status,
             called_at")
    .order("janomaxlead_id, called_at DESC, id DESC")

  joins("
    LEFT JOIN (#{latest_inbound.to_sql}) inbound
      ON inbound.janomaxlead_id = janomaxleads.id
  ")
  .joins("
    LEFT JOIN (#{latest_outbound.to_sql}) outbound
      ON outbound.janomaxlead_id = janomaxleads.id
  ")
  .where(lead_status: "open")
  .where(<<~SQL)
      GREATEST(
        COALESCE(inbound.called_at,'1900-01-01'),
        COALESCE(outbound.called_at,'1900-01-01')
      ) >
      COALESCE(janomaxleads.last_handled_at,'1900-01-01')
  SQL
  .where(<<~SQL)
      CASE
        WHEN COALESCE(inbound.called_at,'1900-01-01')
           >= COALESCE(outbound.called_at,'1900-01-01')
        THEN UPPER(inbound.status)
        ELSE UPPER(outbound.status)
      END <> 'ANSWERED'
  SQL
}

scope :with_latest_call, lambda {
  latest_calls = Janomaxleadcall
    .select("DISTINCT ON (janomaxlead_id)
             janomaxlead_id,
             status,
             called_at")
    .order("janomaxlead_id, called_at DESC, id DESC")

  joins("INNER JOIN (#{latest_calls.to_sql}) latest_call
         ON latest_call.janomaxlead_id = janomaxleads.id")
}

  def activity_timeline
  calls = janomaxleadcalls.map do |c|
    {
      type: "call",
      time: c.called_at,
      data: c
    }
  end

  comments = comments.present? ? [{
    type: "comment",
    time: updated_at,
    data: comments
  }] : []

  (calls + comments).sort_by { |a| a[:time] }.reverse
end

  scope :open_leads, -> { where(lead_status: "open") }
  scope :converted_leads, -> { where(lead_status: "converted") }

  def customer_name
    jmcustomer&.name
  end

  def total_paid
    jmcustomer&.total_paid.to_f
  end

  def existing_customer?
    jmcustomer.present?
  end



  require "csv"

def self.to_csv(leads)
  CSV.generate(headers: true) do |csv|
    csv << [
      "Phone",
      "Customer Name",
      "Lead Status",
      "Customer Exists",
      "Calls Count",
      "Last Status",
      "Last Called At",
      "Comments"
    ]

    leads.find_each do |lead|
      csv << [
        lead.phone,
        lead.jmcustomer&.name,
        lead.lead_status,
        lead.customer_exists,
        lead.calls_count,
        lead.last_status,
        lead.last_called_at,
        lead.comments.to_s.gsub(/\n/, " ")
      ]
    end
  end
end

  # ====================================================
  # IMPORT CDR
  # ====================================================

# ====================================================
# IMPORT CDR (INBOUND + OUTBOUND)
# ====================================================

def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1).map(&:to_s).map(&:strip)

  last_inbound_time  = Janomaxleadcall.maximum(:called_at)
  last_outbound_time = JanomaxOutboundCall.maximum(:called_at)

  (2..spreadsheet.last_row).each do |i|
    begin
      row = Hash[header.zip(spreadsheet.row(i))]

      direction = row["Communication Type"].to_s.strip.upcase

      next unless %w[INBOUND OUTBOUND].include?(direction)

      phone =
        if direction == "INBOUND"
          normalize_phone(row["Call From"])
        else
          normalize_phone(row["Call To"])
        end

      next if phone.blank?

      raw_time = row["Time"].to_s.strip
      next if raw_time.blank?

    called_at =
  begin
    Time.zone.strptime(raw_time, "%m/%d/%Y %H:%M:%S")
  rescue
    Time.zone.parse(raw_time)
  end

      status = row["Last Status"].to_s.strip.upcase

      agent =
        if direction == "INBOUND"
          row["Call To"].to_s.strip
        else
          row["Call From"].to_s.strip
        end

      case direction

      # =====================================================
      # INBOUND
      # =====================================================
      when "INBOUND"

        next if last_inbound_time.present? &&
                called_at <= last_inbound_time

        customer = find_customer(phone)

        lead = Janomaxlead.find_or_initialize_by(phone: phone)

        lead.calls_count     = lead.calls_count.to_i + 1
        lead.last_status     = status
        lead.last_called_at  = called_at
        lead.customer_exists = customer.present?
        lead.jmcustomer      = customer
        lead.lead_status     = customer.present? ? "converted" : "open"

        lead.save!

        lead.janomaxleadcalls.find_or_create_by!(
          called_at: called_at,
          status: status
        ) do |call|
          call.agent     = agent
          call.direction = "INBOUND"
        end

      # =====================================================
      # OUTBOUND
      # =====================================================
      when "OUTBOUND"

        next if last_outbound_time.present? &&
                called_at <= last_outbound_time

        lead = Janomaxlead.find_or_create_by!(phone: phone) do |l|
          customer = find_customer(phone)

          l.customer_exists = customer.present?
          l.jmcustomer      = customer
          l.lead_status     = customer.present? ? "converted" : "open"
        end

        lead.janomax_outbound_calls.find_or_create_by!(
          called_at: called_at,
          status: status
        ) do |call|
          call.phone     = phone
          call.agent     = agent
          call.direction = "OUTBOUND"
        end

      end

    rescue => e
      Rails.logger.error "Row #{i} failed: #{e.message}"
      next
    end
  end
end
  # ====================================================
  # CUSTOMER MATCHING
  # ====================================================

  def self.find_customer(phone)
    Jmcustomer.find_by(phone: phone) ||
    Jmcustomer.find_by(phone: phone.sub(/^0/, "254"))
  end

  # ====================================================
  # PHONE NORMALIZATION
  # ====================================================

def self.normalize_phone(phone)
  return nil if phone.blank?

  phone = phone.to_s.split("<").first

  digits = phone.gsub(/\D/, "")

  if digits.start_with?("254")
    "0#{digits[3..]}"
  elsif digits.length == 9
    "0#{digits}"
  else
    digits
  end
end
  # ====================================================
  # FILE IMPORTS
  # ====================================================

def self.open_spreadsheet(file)
  case File.extname(file.original_filename).downcase
  when ".csv"
    Roo::CSV.new(file.path, csv_options: { encoding: "bom|utf-8" })

  when ".xls"
    Roo::Excel.new(file.path)

  when ".xlsx"
    Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)

  else
    raise "Unknown file type: #{file.original_filename}"
  end
end


end