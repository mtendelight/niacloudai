class Jmcustomer < ApplicationRecord

  audited
  has_many :jmcustomer_items, dependent: :destroy
  has_many :janomaxes, through: :jmcustomer_items
  has_many :jfulfillments, dependent: :destroy
   has_many :jmpayments, dependent: :destroy
   has_many :jmcallcomments, dependent: :destroy

  belongs_to :jmlead, optional: true, touch: true

after_commit :convert_matching_lead, on: :create


 def total_paid
    jmpayments.sum(:amount)
  end

validate :require_comments_if_negative

def require_comments_if_negative
  return unless negative_feedback?
  return if comments.present?

  errors.add(:comments, "⚠️ Please provide comments when feedback is negative.")
end

def negative_feedback?
  feedback.to_s == "negative"
end

  def tier
    amount = total_paid.to_f

    return :platinum if amount > 1_000_000
    return :diamond  if amount >= 500_000
    return :gold     if amount >= 300_000
    return :silver   if amount >= 100_000
    :bronze
  end

  def tier_icon
    case tier
    when :platinum then "💎👑"
    when :diamond  then "💎"
    when :gold     then "🥇"
    when :silver   then "🥈"
    else "🥉"
    end
  end

  def tier_color
    case tier
    when :platinum then "text-warning"
    when :diamond  then "text-primary"
    when :gold     then "text-success"
    when :silver   then "text-secondary"
    else "text-muted"
    end
  end

  def tier_label
    tier.to_s.capitalize
  end

  accepts_nested_attributes_for :jmcustomer_items, allow_destroy: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }


   def redeem_points!(points_to_redeem)
    raise ArgumentError, "Invalid points" if points_to_redeem.to_i <= 0
    raise ArgumentError, "Insufficient points" if points < points_to_redeem

    update!(points: points - points_to_redeem)
  end
  

  def fulfillment_key(customer, transaction_ref)
  "#{customer.id}-#{transaction_ref.to_s.strip.upcase}"
end

  attr_accessor :is_importing

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, format: { with: /\A0\d{9}\z/, message: "must start with 0 and be exactly 10 digits" }

  before_create :set_returning_if_exists

  after_commit :send_sms_on_create, on: :create
  after_commit :send_sms_on_update, on: :update, unless: :is_importing

  def self.ransackable_attributes(auth_object = nil)
    %w[name phone location]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  has_many :today_items, -> {
    joins(:jmcustomer_items)
      .where("jmcustomer_items.created_at >= ?", Time.zone.now.beginning_of_day)
  }, through: :jmcustomer_items, source: :janomax



require "csv"

def self.to_csv(records)
  headers = [
    "Name",
    "Phone",
    "Location",
    "Items",
    "Qty",
    "Points",
    "Returning",
    "Updated At"
  ]

  CSV.generate(headers: true) do |csv|
    csv << headers

    records.find_each do |c|
      items_text = c.janomaxes.map(&:item_name).tally.map do |name, count|
        count > 1 ? "#{name} - #{count}" : name
      end.join(", ")

      csv << [
        c.name,
        c.phone,
        c.location,
        items_text,
        c.janomaxes.count,
        c.points,
        c.returning? ? "Yes" : "No",
        c.updated_at
      ]
    end
  end
end

def convert_matching_lead
  return if jmlead_id.present?
  

  normalized = normalize_phone(phone)

  # 🚀 FAST: SQL-only match, ignores whitespace differences
  lead = Jmlead.where(status: "open")
               .find_by("REPLACE(phone, ' ', '') LIKE ?", "%#{normalized.last(9)}")

  return unless lead

  lead.with_lock do
    next if lead.status == "converted"

    update_column(:jmlead_id, lead.id)

    lead.update!(
      status: "converted",
      converted_at: Time.current
    )
  end
end

  private


def normalize_phone(num)
  num = num.to_s.gsub(/\D/, "")

  return num[-9..] if num.length > 9
  num
end




  # Prevent duplicate customers by phone
 def set_returning_if_exists
  existing_customer = Jmcustomer.find_by(phone: self.phone)
  self.returning = true if existing_customer
end

  

def send_sms_on_create
  return if is_importing
  send_thank_you_sms
end

def send_sms_on_update
  return if is_importing

  if saved_change_to_updated_at? || jmcustomer_items.any? { |i| i.saved_change_to_janomax_id? }
    send_thank_you_sms
    Rails.logger.info("✅ SMS sent for Jmcustomer##{id} on update")
  else
    Rails.logger.info("ℹ️ No SMS sent for Jmcustomer##{id} — no meaningful change")
  end
end

  def send_thank_you_sms
  return if is_importing

  first_name = name.to_s.strip.split(' ').first

  message = "Dear #{first_name}, thank you for purchasing a bale with Janomax Premium Bales. We appreciate your continued support!"

  sms_service = SmsService.new(
    api_key: ENV['TEXTSMS_API_KEY'],
    partner_id: ENV['TEXTSMS_PARTNER_ID']
  )

  response = sms_service.send_sms(phone, message)

  Rails.logger.info("💬 SMS response for Jmcustomer##{id}: #{response}")

rescue => e
  Rails.logger.error("❌ Failed to send SMS for Jmcustomer##{id}: #{e.message}")
end

  public

  # Import customers and remove duplicate jmcustomer_items automatically
  def self.import(file, skip_blanks: true)
    allowed_attributes = ["name", "phone", "location"]

    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      next if skip_blanks && row["phone"].blank?

      ticket = Jmcustomer.find_or_initialize_by(phone: row["phone"])
      if ticket.persisted?
        puts "Janomax Customer #{row["phone"]} already exists. Skipping..."
        next
      end

      ticket.attributes = row.to_hash.slice(*allowed_attributes)
      ticket.is_importing = true
      ticket.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
    when '.xls' then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  # Ensure nested jmcustomer_items are unique by janomax_id
  before_save do
    if jmcustomer_items.loaded?
      unique_items = jmcustomer_items.uniq { |item| item.janomax_id }
      self.jmcustomer_items = unique_items
    end
  end
end
