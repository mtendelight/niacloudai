# app/services/customer_care_notification_service.rb

class CustomerCareNotificationService
  def self.notify(customer_phone:, customer_name:, message:)
    text = <<~TEXT
      📢 Customer Care Notification

      Customer: #{customer_name.presence || "Unknown"}
      Phone: +#{customer_phone}

      Customer Message:
      #{message}

      Please follow up with this customer as soon as possible.
    TEXT

    WhatsappService.send_message("254747316282", text)
    WhatsappService.send_message("254740919499", text)
    WhatsappService.send_message("254797441149", text)
    WhatsappService.send_message("254111555749", text)
    WhatsappService.send_message("254762333443", text)
  end
end