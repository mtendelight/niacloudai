require "sidekiq/api"
class JmaiController < ApplicationController
  before_action :set_customer, only: [:send_offer_sms_to_one]
before_action :authenticate_user!
def index
  per_page = params.fetch(:per_page, 10).to_i
  per_page = 10 if per_page <= 0

  scope = Jmcustomer.all

  case params[:filter]
  when "1_month"
    scope = scope.where("updated_at >= ?", 1.month.ago)

  when "1_to_3"
    scope = scope.where(updated_at: 3.months.ago..1.month.ago)

  when "3_to_6"
    scope = scope.where(updated_at: 6.months.ago..3.months.ago)

  when "over_6"
    scope = scope.where("updated_at <= ?", 6.months.ago)
  end

@jmcustomers = scope
                 .where("updated_at <= ?", 7.days.ago)
                 .order(updated_at: :desc)
                 .page(params[:page])
                 .per(per_page)
@items_by_customer =
  JmcustomerItem
    .joins(:janomax)
    .where(jmcustomer_id: @jmcustomers.pluck(:id))
    .group(:jmcustomer_id)
    .pluck(
      :jmcustomer_id,
      Arel.sql("STRING_AGG(DISTINCT janomaxes.item_name, ', ')")
    )
    .to_h

  sms_service = TextsmsService.new(
    api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
    partner_id: "14784",
    shortcode: "JANOMAX"
  )

  balance_result = sms_service.balance

  @sms_balance =
    if balance_result.is_a?(Hash) && balance_result["error"].present?
      "Error fetching balance"
    else
      balance_result.to_s
    end


     @sidekiq_stats = Sidekiq::Stats.new
  @sidekiq_workers = Sidekiq::Workers.new
  @sidekiq_queue = Sidekiq::Queue.new
  @sidekiq_retry = Sidekiq::RetrySet.new
  @sidekiq_dead = Sidekiq::DeadSet.new
end



def send_bulk_sms
  unless params[:file].present?
    redirect_back(
      fallback_location: jmai_index_path,
      alert: "Please select an Excel file."
    )
    return
  end

  file = params[:file]

  unless File.extname(file.original_filename).downcase.in?(%w[.xlsx .xls])
    redirect_back(
      fallback_location: jmai_index_path,
      alert: "Please upload an Excel file (.xlsx or .xls)."
    )
    return
  end

  message = params[:message].to_s.strip

  if message.blank?
    redirect_back(
      fallback_location: jmai_index_path,
      alert: "Please enter the SMS message."
    )
    return
  end

  begin
    spreadsheet = Roo::Spreadsheet.open(file.path)
    sheet = spreadsheet.sheet(0)

    if sheet.last_row.nil? || sheet.last_row < 2
      redirect_back(
        fallback_location: jmai_index_path,
        alert: "The Excel file does not contain any recipients."
      )
      return
    end

    # ============================================
    # READ HEADERS
    # ============================================

    headers = sheet.row(1).map do |header|
      header.to_s.strip.downcase.gsub(/\s+/, "_")
    end

    name_index = headers.index do |header|
      header.in?(%w[
        name
        customer_name
        customer
      ])
    end

    phone_index = headers.index do |header|
      header.in?(%w[
        phone
        mobile
        mobile_number
        telephone
      ])
    end

    points_index = headers.index do |header|
      header.in?(%w[
        points
        customer_points
      ])
    end

    location_index = headers.index do |header|
      header.in?(%w[
        location
        customer_location
        town
        city
      ])
    end

    unless name_index && phone_index
      redirect_back(
        fallback_location: jmai_index_path,
        alert: "Excel must contain Name and Phone columns."
      )
      return
    end

    # ============================================
    # READ RECIPIENTS
    # ============================================

    recipients = []

    (2..sheet.last_row).each do |row_number|

      row = sheet.row(row_number)

      name = row[name_index].to_s.strip
      phone = row[phone_index].to_s.strip

      next if phone.blank?

      phone = normalize_sms_phone(phone)

      # Skip invalid phone numbers
      next if phone.blank?

      points =
        if points_index
          row[points_index].to_s.strip
        else
          ""
        end

      location =
        if location_index
          row[location_index].to_s.strip
        else
          ""
        end

      recipients << {
        name: name.presence || "Customer",
        phone: phone,
        points: points,
        location: location
      }
    end

    # ============================================
    # NO VALID RECIPIENTS
    # ============================================

    if recipients.empty?
      redirect_back(
        fallback_location: jmai_index_path,
        alert: "No valid recipients were found in the Excel file."
      )
      return
    end

    # ============================================
    # SEND IN BATCHES THROUGH SIDEKIQ
    # ============================================

    recipients.each_slice(50) do |batch|
      BulkSmsJob.perform_later(batch, message)
    end

    # ============================================
    # SUCCESS
    # ============================================

    redirect_back(
      fallback_location: jmai_index_path,
      notice: "#{recipients.size} SMS messages have been queued for sending."
    )

  rescue Roo::HeaderRowNotFoundError => e

    Rails.logger.error(
      "Bulk SMS Excel header error: #{e.message}"
    )

    redirect_back(
      fallback_location: jmai_index_path,
      alert: "Could not read the Excel headers. Please check the file."
    )

  rescue => e

    Rails.logger.error(
      "Bulk SMS Excel import failed: #{e.class} - #{e.message}"
    )

    redirect_back(
      fallback_location: jmai_index_path,
      alert: "Could not process the Excel file: #{e.message}"
    )
  end
end

def send_single_sms
  if params[:phone].blank? || params[:message].blank?
    redirect_to jmai_index_path,
                alert: "Phone number and message are required."
    return
  end

  sms_service = TextsmsService.new(
    api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
    partner_id: "14784",
    shortcode: "JANOMAX"
  )

  sms = params[:message].to_s
          .gsub("{name}", params[:name].presence || "Customer")

  sms += "\n\n- Janomax Premium Bales"

  begin
    sms_service.send_sms(params[:phone], sms)

    redirect_to jmai_index_path,
                notice: "SMS sent successfully to #{params[:phone]}."

  rescue => e

    Rails.logger.error(e.message)

    redirect_to jmai_index_path,
                alert: "Failed to send SMS."

  end
end


def preview_offer_sms
  filter = params[:filter].to_s.strip

  customers =
    case filter

    when "all"
      Jmcustomer.all

    when "1_month"
      Jmcustomer.where("updated_at >= ?", 1.month.ago)

    when "1_to_3"
      Jmcustomer.where(updated_at: 3.months.ago..1.month.ago)

    when "3_to_6"
      Jmcustomer.where(updated_at: 6.months.ago..3.months.ago)

    when "over_6"
      Jmcustomer.where("updated_at <= ?", 6.months.ago)

    else
      Jmcustomer.none
    end

  total = customers.count

  valid_customers =
    customers
      .where.not(phone: [nil, ""])
      .where.not(blacklist: true)

  valid_count = valid_customers.count

  invalid_count = total - valid_count

  sample_customers =
    valid_customers
      .order(updated_at: :desc)
      .limit(5)

  render json: {
    total: total,
    valid_count: valid_count,
    invalid_count: invalid_count,

    customers: sample_customers.map do |customer|
      {
        name: customer.name.to_s,
        phone: customer.phone.to_s,
        points: customer.points.to_s,
        location: customer.location.to_s
      }
    end
  }
end


def sms_campaign
end

def send_custom_sms
  if params[:message].blank?
    redirect_to jmai_index_path,
                alert: "Please enter an SMS message."
    return
  end

  CustomSmsCampaignJob.perform_later(
    params[:recipient_type],
    params[:message]
  )

  redirect_to jmai_index_path,
              notice: "SMS campaign has been queued and is being sent in the background."
end

def send_offer_sms
  if params[:message].blank?
    redirect_to jmai_index_path,
                alert: "Please enter an SMS message."
    return
  end

  BulkSmsCampaignJob.perform_later(
    params[:filter],
    params[:message]
  )

  redirect_to jmai_index_path,
              notice: "Bulk SMS campaign has been queued and is being sent in the background."
end

# ✅ Send to All Customers
def send_offer_sms_to_all
  OfferSmsToAllJob.perform_later

  redirect_to jmai_index_path,
              notice: "Offer SMS campaign has been queued and is being sent in the background."
end


  # ✅ Send to One Customer
  def send_offer_sms_to_one
    sms_service = TextsmsService.new(
      api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
      partner_id: '14784',
      shortcode: 'JANOMAX'
    )

    message = "Dear #{@customer.name}, enjoy an exclusive offer on your next bale! Visit Janomax Premium Bales today — offer valid for 2 days only!"
    response = sms_service.send_sms(@customer.phone, message)

    Rails.logger.info "✅ Offer SMS sent to #{@customer.phone}: #{response.inspect}"
    redirect_to jmai_index_path, notice: "Offer SMS sent to #{@customer.name}."
  end



  private

  def set_customer
    @customer = Jmcustomer.find(params[:id])
  end


def normalize_sms_phone(phone)
  phone = phone.to_s.gsub(/\D/, "")

  if phone.start_with?("0")
    phone = "254#{phone[1..]}"
  elsif phone.start_with?("7") || phone.start_with?("1")
    phone = "254#{phone}"
  end

  return if phone.blank?

  phone if phone.match?(/\A254[17]\d{8}\z/)
end
end
