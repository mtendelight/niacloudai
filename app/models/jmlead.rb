class Jmlead < ApplicationRecord
  has_paper_trail
  audited

  enum :status, {
    open: "open",
    converted: "converted"
  }

  has_one :jmcustomer, dependent: :destroy

  belongs_to :jstaff, optional: true

scope :uncontacted, -> {
  where(status: %w[open converted])
    .where.not(last_customer_message_at: nil)
    .where.not(phone: %w[0747316282 0714316282])
    .where(
      "last_handled_at IS NULL
       OR last_customer_message_at > last_handled_at"
    )
}




def parsed_comments
  messages = []
  speaker  = nil
  buffer   = []

  # ==========================================
  # EXISTING JMLEAD COMMENTS
  #
  # Customer / AI / Human
  # ==========================================

  comments.to_s.each_line do |line|
    line = line.rstrip

    if line.start_with?("Customer:")

      if speaker
        messages << {
          speaker: speaker,
          body: buffer.join("\n").strip,
          created_at: nil
        }
      end

      speaker = :customer
      buffer = [line.sub("Customer:", "").strip]

    elsif line.start_with?("AI:")

      if speaker
        messages << {
          speaker: speaker,
          body: buffer.join("\n").strip,
          created_at: nil
        }
      end

      speaker = :ai
      buffer = [line.sub("AI:", "").strip]

    elsif line.start_with?("Human:")

      if speaker
        messages << {
          speaker: speaker,
          body: buffer.join("\n").strip,
          created_at: nil
        }
      end

      speaker = :human
      buffer = [line.sub("Human:", "").strip]

    else
      buffer << line
    end
  end

  # ==========================================
  # FINISH LAST COMMENT
  # ==========================================

  if speaker
    messages << {
      speaker: speaker,
      body: buffer.join("\n").strip,
      created_at: nil
    }
  end

  # ==========================================
  # GET LATEST 4 HUMAN REPLIES
  #
  # Database gives:
  # latest -> oldest
  # ==========================================

  human_messages = []

  begin
    phone = self.phone.to_s.strip

    if phone.present?

      customer = Aicustomer.find_by(phone: phone)

      conversation = customer&.aiconversations&.last

      if conversation

        human_messages =
          conversation.aimessages
            .where(role: "staff")
            .order(created_at: :desc)
            .limit(2)
            .map do |message|

              {
                speaker: :human,
                body: message.content.to_s.strip,
                created_at: message.created_at
              }

            end

      end
    end

  rescue => e

    Rails.logger.error(
      "[Jmlead#parsed_comments] #{e.class}: #{e.message}"
    )

  end

  # ==========================================
  # REMOVE HUMAN FROM OLD JMLEAD COMMENTS
  #
  # Human messages will come from Aimessage
  # instead.
  # ==========================================

  customer_ai_messages =
    messages.reject do |message|
      message[:speaker] == :human
    end

  # ==========================================
  # KEEP CUSTOMER + AI IN NORMAL ORDER
  #
  # IMPORTANT:
  # NO reverse here
  # ==========================================

  # ==========================================
  # HUMAN MESSAGES
  #
  # Database order:
  # [0] latest
  # [1] previous
  # [2] previous
  # [3] previous
  #
  # We reverse them so they display normally:
  #
  # oldest -> latest
  # ==========================================

  human_messages =
    human_messages.reverse

  # ==========================================
  # FINAL ORDER
  #
  # Customer / AI first
  # Previous Human messages
  # Latest Human message at bottom
  # ==========================================

  result = []

  result.concat(customer_ai_messages)

  result.concat(human_messages)

  result
end




  before_validation :normalize_phone
   before_validation :set_default_name
  before_create :generate_sglid

  validates :phone,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A0\d{9}\z/,
              message: "must be a valid Kenyan mobile number"
            }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name phone sglid]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  # Reusable phone normalizer
  def self.normalize_phone(phone)
    return "" if phone.blank?

    number = phone.to_s.strip

    # Remove spaces, hyphens and brackets
    number = number.gsub(/[^\d+]/, "")

    case number
    when /\A\+254\d{9}\z/
      "0#{number[4..]}"
    when /\A254\d{9}\z/
      "0#{number[3..]}"
    when /\A0\d{9}\z/
      number
    else
      number
    end
  end

  private

  def normalize_phone
    self.phone = self.class.normalize_phone(phone)
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv"
      Roo::Csv.new(file.path, nil, :ignore)
    when ".xls"
      Roo::Excel.new(file.path)
    when ".xlsx"
      Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

    def set_default_name
    self.name = "Lead Customer" if name.blank?
  end

  def generate_sglid
    current_year = Time.current.year

    last_sglid = Jmlead
      .where("sglid LIKE ?", "sgl_#{current_year}_%")
      .order(:created_at)
      .last
      &.sglid

    last_number =
      if last_sglid.present?
        last_sglid.split("_").last.to_i
      else
        110000
      end

    self.sglid = "sgl_#{current_year}_#{last_number + 1}"
  end
end