class SendCustomerCareSmsJob < ApplicationJob
  queue_as :default

  CUSTOMER_CARE_NUMBERS = %w[
    254714316282
    254740919499
    254111555749
    254762333443
  ].freeze

  def perform(customer_phone:, customer_name:, message:)
    sms_service = TextsmsService.new(
      api_key: ENV.fetch("TEXTSMS_API_KEY", "07f5a8a2cbf54a4bb8cd42eff0b28ece"),
      partner_id: ENV.fetch("TEXTSMS_PARTNER_ID", "14784"),
      shortcode: ENV.fetch("TEXTSMS_SHORTCODE", "JANOMAX")
    )

    sms = <<~MSG
🚨 CUSTOMER CARE ALERT

Customer: #{customer_name.presence || "Unknown"}
Phone: #{customer_phone}

Message:
#{message}

Please contact the customer as soon as possible.

- Janomax AI
MSG

    sent = 0
    failed = 0

    CUSTOMER_CARE_NUMBERS.each do |phone|
      begin
        sms_service.send_sms(phone, sms)

        sent += 1

        Rails.logger.info(
          "✅ Customer Care SMS sent to #{phone}"
        )

      rescue => e
        failed += 1

        Rails.logger.error(
          "❌ Failed sending Customer Care SMS to #{phone}: #{e.message}"
        )
      end

      # avoid provider throttling
      sleep 0.2
    end

    Rails.logger.info(
      "Customer Care SMS completed. Sent=#{sent}, Failed=#{failed}"
    )
  end
end