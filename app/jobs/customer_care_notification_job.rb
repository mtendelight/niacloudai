class CustomerCareNotificationJob < ApplicationJob
  queue_as :default

  def perform(customer_phone:, customer_name:, message:)
    CustomerCareNotificationService.notify(
      customer_phone: customer_phone,
      customer_name: customer_name,
      message: message
    )

  rescue => e
    Rails.logger.error("[CustomerCareNotificationJob] #{e.class}: #{e.message}")
  end
end