class BulkSmsCampaignJob < ApplicationJob
  queue_as :default

  def perform(filter, message)

    filter = filter.to_s.strip
    sms_service = TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    )

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

    sent = 0
    failed = 0

    customers.where.not(phone: [nil, ""]).find_each do |customer|
      sms = message.to_s
              .gsub("{name}", customer.name.to_s)
              .gsub("{points}", customer.points.to_s)
              .gsub("{location}", customer.location.to_s)

      sms += "\n\n- Janomax Premium Bales"

      begin
        sms_service.send_sms(customer.phone, sms)
        sent += 1

        Rails.logger.info(
          "✅ Bulk SMS sent to #{customer.name} (#{customer.phone})"
        )

      rescue => e
        failed += 1

        Rails.logger.error(
          "❌ Bulk SMS failed for #{customer.name} (#{customer.phone}): #{e.message}"
        )
      end

      # Prevent hitting the SMS provider's rate limits
      sleep 0.3
    end

    Rails.logger.info(
      "🎉 Bulk SMS Campaign Completed. Sent: #{sent}, Failed: #{failed}"
    )
  end
end