class SaveLeadJob < ApplicationJob
  queue_as :default

  def perform(phone:, customer_name:, text:, reply:)
    normalized_phone = Jmlead.normalize_phone(phone)

    lead = Jmlead.find_or_initialize_by(phone: normalized_phone)

    lead.name = customer_name if customer_name.present?
    lead.items_required = text
    lead.status ||= "open"

    # 👇 Customer has just sent a new message
    lead.last_customer_message_at = Time.current

    lead.comments = [
      lead.comments,
      "Customer: #{text}",
      "AI: #{reply}"
    ].compact.reject(&:blank?).join("\n\n")

    lead.save!

  rescue => e
    Rails.logger.error("[SaveLeadJob] #{e.class}: #{e.message}")
  end
end