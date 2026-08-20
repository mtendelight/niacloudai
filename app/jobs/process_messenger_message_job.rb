# app/jobs/process_messenger_message_job.rb

class ProcessMessengerMessageJob < ApplicationJob
  queue_as :default

  CUSTOMER_CARE_PHONES = %w[
    254714316282
    254740919499
    254111555749
    254762333443
  ].freeze

  def perform(payload)
    entry = payload.dig("entry", 0)
    return unless entry

    messaging = entry.dig("messaging", 0)
    return unless messaging

    # Ignore delivery/read/reaction events
    if messaging["delivery"].present? ||
       messaging["read"].present? ||
       messaging["reaction"].present?
      Rails.logger.info("[Messenger] Ignoring non-message webhook")
      return
    end

    message = messaging["message"]
    return unless message

    sender_id = messaging.dig("sender", "id")
    return if sender_id.blank?

    text = message["text"].to_s.strip
    return if text.blank?

    customer = Aicustomer.find_or_create_by!(phone: sender_id)

    conversation =
      customer.aiconversations.last ||
      customer.aiconversations.create!

    conversation.aimessages.create!(
      role: "user",
      phone: sender_id,
      message_type: "text",
      content: text
    )

    reply = OpenaiService.new(conversation).reply

    conversation.aimessages.create!(
      role: "assistant",
      phone: sender_id,
      message_type: "text",
      content: reply
    )

    needs_customer_care =
      reply.match?(/\[NOTIFY_CUSTOMER_CARE\]/i) ||
      reply.match?(/\[CUSTOMER_CARE\]/i) ||
      reply.match?(/team member|customer care|human agent|representative|contact us/i)

    reply = reply
              .gsub(/\[NOTIFY_CUSTOMER_CARE\]/i, "")
              .gsub(/\[CUSTOMER_CARE\]/i, "")
              .strip

    # Send AI reply back to Messenger
    MessengerService.send_message(sender_id, reply)

    # Save/update CRM lead
    SaveLeadJob.perform_later(
      phone: sender_id,
      customer_name: customer.name,
      text: text,
      reply: reply
    )

    # Notify customer care if needed
    if needs_customer_care
      CustomerCareNotificationJob.perform_later(
        customer_phone: sender_id,
        customer_name: customer.name,
        message: text
      )

      SendCustomerCareSmsJob.perform_later(
        customer_phone: sender_id,
        customer_name: customer.name,
        message: text
      )
    end

    # Log incoming message
    SaveAiLogJob.perform_later(
      aicustomer_id: customer.id,
      phone: sender_id,
      customer_name: customer.name,
      text: text,
      channel: "facebook"
    )

  rescue => e
    Rails.logger.error("[ProcessMessengerMessageJob] #{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end
end