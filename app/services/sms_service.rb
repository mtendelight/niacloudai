# app/services/sms_service.rb
require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class SmsService
  BASE_URL = 'https://sms.textsms.co.ke/api/services/sendsms/'.freeze

  def initialize(api_key:, partner_id:, shortcode: 'JANOMAX')
    @api_key = api_key
    @partner_id = partner_id
    @shortcode = shortcode
  end

  def send_sms(mobile, message)
    if Rails.env.development? || Rails.env.test?
      Rails.logger.info("💬 [DEV MODE] Would send SMS to #{mobile}: #{message}")
      return { "status" => "mocked", "message" => "SMS not sent in dev/test mode" }
    end

    uri = URI(BASE_URL)
    payload = {
      apikey: @api_key,
      partnerID: @partner_id,
      message: message,
      shortcode: @shortcode,
      mobile: normalize_phone(mobile)
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Only for local/dev

    headers = { 'Content-Type' => 'application/json' }
    response = http.post(uri.path, payload.to_json, headers)

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("TEXTSMS parse error: #{e.message} — Response: #{response&.body}")
    { "error" => response&.body }
  rescue => e
    Rails.logger.error("TEXTSMS fatal error: #{e.message}")
    { "error" => e.message }
  end

  private

  def normalize_phone(phone)
    p = phone.to_s.strip
    p = p.sub(/^0/, '254') if p.start_with?('0')
    p
  end
end
