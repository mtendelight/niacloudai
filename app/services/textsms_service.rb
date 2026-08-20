require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class TextsmsService
  BASE_URL = 'https://sms.textsms.co.ke/api/services/sendsms/'.freeze
  BALANCE_URL = 'https://sms.textsms.co.ke/api/services/getbalance/'.freeze

  def initialize(api_key:, partner_id:, shortcode: 'JANOMAX')
    @api_key = api_key
    @partner_id = partner_id
    @shortcode = shortcode
  end

  # ✅ Send a single SMS
  def send_sms(mobile, message)
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
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    headers = { 'Content-Type' => 'application/json' }
    response = http.post(uri.path, payload.to_json, headers)

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("TEXTSMS send error: #{e.message} — Response: #{response&.body}")
    { "error" => response&.body }
  rescue => e
    Rails.logger.error("TEXTSMS fatal error: #{e.message}")
    { "error" => e.message }
  end

  # ✅ Get SMS balance (pending units)
  def balance
    uri = URI(BALANCE_URL)
    payload = {
      apikey: @api_key,
      partnerID: @partner_id
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    headers = { 'Content-Type' => 'application/json' }
    response = http.post(uri.path, payload.to_json, headers)

    json = JSON.parse(response.body) rescue {}

    # The API usually returns something like: { "balance": "1234" }
    json["balance"] || json["units"] || json["credit"] || response.body
  rescue => e
    Rails.logger.error("TEXTSMS balance check error: #{e.message}")
    { "error" => e.message }
  end

  private

  def normalize_phone(phone)
    p = phone.to_s.strip
    p = p.sub(/^0/, '254') if p.start_with?('0')
    p
  end
end
