class ProcessWhatsappMessageJob < ApplicationJob
  queue_as :default

  CUSTOMER_CARE_PHONES = %w[
    254714316282
    254747316282
    254740919499
    254111555749
    254762333443
  ].freeze

  def perform(payload)

    value = payload.dig(
      "entry", 0,
      "changes", 0,
      "value"
    )

    return unless value

    # ==========================================
    # IGNORE DELIVERY / READ STATUS WEBHOOKS
    # ==========================================

    if value["statuses"].present?
      Rails.logger.info(
        "[WhatsApp] Ignoring status webhook"
      )

      return
    end

    message = value.dig(
      "messages", 0
    )

    return unless message

    # ==========================================
    # MESSAGE ID
    # ==========================================

    whatsapp_message_id =
      message["id"].to_s

    if whatsapp_message_id.blank?
      Rails.logger.warn(
        "[WhatsApp] Message has no ID"
      )

      return
    end

    # ==========================================
    # PREVENT DUPLICATES
    # ==========================================

    if Aimessage.exists?(
      whatsapp_message_id: whatsapp_message_id
    )
      Rails.logger.info(
        "[WhatsApp] Duplicate message ignored: #{whatsapp_message_id}"
      )

      return
    end

    # ==========================================
    # PHONE
    # ==========================================

    phone =
      message["from"].to_s.strip

    return if phone.blank?

    # ==========================================
    # TEXT
    # ==========================================

    text =
      message.dig(
        "text",
        "body"
      ).to_s.strip

    # Ignore unsupported message types
    if text.blank?

      Rails.logger.info(
        "[WhatsApp] Unsupported message type: #{message["type"]}"
      )

      return
    end

    # ==========================================
    # CUSTOMER
    # ==========================================

    customer =
      Aicustomer.find_or_create_by!(
        phone: phone
      )

    # ==========================================
    # CONVERSATION
    # ==========================================

    conversation =
      customer.aiconversations.last ||
      customer.aiconversations.create!

    # ==========================================
    # SAVE CUSTOMER MESSAGE
    # ==========================================

    conversation.aimessages.create!(
      role: "user",
      phone: phone,
      message_type: "text",
      content: text,
      whatsapp_message_id: whatsapp_message_id
    )

    Rails.logger.info(
      "[WhatsApp] Incoming message from #{phone}: #{text}"
    )

    # ==========================================
    # AI REPLY
    # ==========================================

    reply =
      OpenaiService
        .new(conversation)
        .reply
        .to_s
        .strip

    reply =
      "Thank you for contacting Janomax Premium Bales. " \
      "Our team will assist you shortly." if reply.blank?

    # ==========================================
    # CUSTOMER CARE DETECTION
    # ==========================================

    needs_customer_care =
      reply.match?(/\[NOTIFY_CUSTOMER_CARE\]/i) ||
      reply.match?(/\[CUSTOMER_CARE\]/i) ||
      reply.match?(
        /team member|customer care|human agent|representative|contact us/i
      )

    # ==========================================
    # PAYMENT / WHATSAPP NOTIFICATION
    # ==========================================

    payment_notification = nil

    if reply.match?(
      /\[WHATSAPP_PAYMENT_NOTIFICATION\](.*?)\[\/WHATSAPP_PAYMENT_NOTIFICATION\]/im
    )

      payment_notification =
        reply.match(
          /\[WHATSAPP_PAYMENT_NOTIFICATION\](.*?)\[\/WHATSAPP_PAYMENT_NOTIFICATION\]/im
        )[1].to_s.strip

      needs_customer_care = true

      Rails.logger.info(
        "[WhatsApp] Payment notification detected for #{phone}"
      )
    end

    # ==========================================
    # REMOVE INTERNAL BLOCKS
    # ==========================================

    customer_reply =
      reply
        .gsub(
          /\[WHATSAPP_PAYMENT_NOTIFICATION\].*?\[\/WHATSAPP_PAYMENT_NOTIFICATION\]/im,
          ""
        )
        .gsub(/\[NOTIFY_CUSTOMER_CARE\]/i, "")
        .gsub(/\[CUSTOMER_CARE\]/i, "")
        .strip

    customer_reply =
      "Thank you for contacting Janomax Premium Bales. " \
      "Our team will assist you shortly." if customer_reply.blank?

    # ==========================================
    # SAVE AI REPLY
    # ==========================================

    conversation.aimessages.create!(
      role: "assistant",
      phone: phone,
      message_type: "text",
      content: customer_reply
    )

    # ==========================================
    # SEND WHATSAPP REPLY TO CUSTOMER
    # ==========================================

    WhatsappService.send_message(
      phone,
      customer_reply
    )

    # ==========================================
    # CRM
    # ==========================================

    SaveLeadJob.perform_later(
      phone: phone,
      customer_name: customer.name,
      text: text,
      reply: customer_reply
    )

    # ==========================================
    # CUSTOMER CARE
    # ==========================================

    if needs_customer_care

      # ------------------------------------------
      # Customer Care Notification
      # ------------------------------------------

      CustomerCareNotificationJob.perform_later(
        customer_phone: phone,
        customer_name: customer.name,
        message: payment_notification.presence || text
      )

      # ------------------------------------------
      # Customer Care SMS
      # ------------------------------------------

      SendCustomerCareSmsJob.perform_later(
        customer_phone: phone,
        customer_name: customer.name,
        message: payment_notification.presence || text
      )

      # ------------------------------------------
      # Customer Care WhatsApp
      # ------------------------------------------

      CustomerCareWhatsappJob.perform_later(
        customer_phone: phone,
        customer_name: customer.name,
        message: payment_notification.presence || text
      )

    end

    # ==========================================
    # AI LOG
    # ==========================================

    SaveAiLogJob.perform_later(
      aicustomer_id: customer.id,
      phone: phone,
      customer_name: customer.name,
      text: text,
      channel: "whatsapp"
    )

    Rails.logger.info(
      "[WhatsApp] Message processed successfully for #{phone}"
    )

  rescue => e

    Rails.logger.error(
      "[ProcessWhatsappMessageJob] #{e.class}: #{e.message}"
    )

    Rails.logger.error(
      e.backtrace.join("\n")
    )

    raise
  end
end
