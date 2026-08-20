class OfferSmsToAllJob < ApplicationJob
  queue_as :default

  def perform
    sms_service = TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    )

    sent = 0
    failed = 0

    Jmcustomer
      .where.not(phone: [nil, ""])
      .find_each do |customer|

      sms = <<~MSG
Dear #{customer.name},

Enjoy an exclusive offer on your next bale at Janomax Premium Bales!

Visit us today and take advantage of this limited-time offer.

Call/WhatsApp: 0740919499

- Janomax Premium Bales
MSG

      begin
        sms_service.send_sms(customer.phone, sms)

        sent += 1

        Rails.logger.info(
          "✅ Offer SMS sent to #{customer.name} (#{customer.phone})"
        )

      rescue => e

        failed += 1

        Rails.logger.error(
          "❌ Offer SMS failed for #{customer.name} (#{customer.phone}): #{e.message}"
        )

      end

      # Throttle requests to avoid hitting provider rate limits
      sleep 0.3
    end

    Rails.logger.info(
      "🎉 Offer SMS Campaign Completed. Sent: #{sent}, Failed: #{failed}"
    )
  end
end