class BulkSmsJob < ApplicationJob
  queue_as :default

  def perform(recipients, message)

    sms_service = TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    )

    sent = 0
    failed = 0

    recipients.each do |recipient|

      name = recipient[:name].to_s
      phone = recipient[:phone].to_s
      points = recipient[:points].to_s
      location = recipient[:location].to_s

      # ============================================
      # PERSONALIZE MESSAGE
      # ============================================

      sms = message.to_s
        .gsub("{name}", name)
        .gsub("{points}", points)
        .gsub("{location}", location)

      # ============================================
      # SEND SMS
      # ============================================

      begin

        sms_service.send_sms(phone, sms)

        sent += 1

        Rails.logger.info(
          "✅ Bulk SMS sent to #{name} (#{phone})"
        )

      rescue => e

        failed += 1

        Rails.logger.error(
          "❌ Bulk SMS failed for #{name} (#{phone}): #{e.message}"
        )

      end

      # Prevent provider rate limiting
      sleep 0.3
    end

    Rails.logger.info(
      "🎉 Excel Bulk SMS Completed. Sent: #{sent}, Failed: #{failed}"
    )
  end
end