class CustomerCareWhatsappJob < ApplicationJob
  queue_as :default

  CUSTOMER_CARE_NUMBERS = %w[
    254714316282
    254740919499
    254111555749
    254762333443
    254747316282
  ].freeze

  def perform(
    customer_phone:,
    customer_name:,
    message:
  )

    whatsapp_message = <<~MSG
      🚨 *JANOMAX CUSTOMER CARE ALERT*

      *Customer:* #{customer_name.presence || "Unknown"}
      *Phone:* #{customer_phone}

      *Details:*
      #{message}

      Please contact the customer as soon as possible.

      _- Janomax AI_
    MSG

    sent = 0
    failed = 0

    CUSTOMER_CARE_NUMBERS.each do |phone|

      begin

        CustomerCareWhatsappService.send_message(
          phone: phone,
          message: whatsapp_message
        )

        sent += 1

        Rails.logger.info(
          "✅ Customer Care WhatsApp sent to #{phone}"
        )

      rescue => e

        failed += 1

        Rails.logger.error(
          "❌ Failed sending Customer Care WhatsApp to #{phone}: #{e.message}"
        )

      end

    end

    Rails.logger.info(
      "Customer Care WhatsApp completed. Sent=#{sent}, Failed=#{failed}"
    )
  end
end
