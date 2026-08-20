# app/jobs/save_ai_log_job.rb

class SaveAiLogJob < ApplicationJob
  queue_as :default

  CHANNELS = %w[
    whatsapp
    facebook
    instagram
    tiktok
  ].freeze

  def perform(
    aicustomer_id:,
    phone:,
    customer_name:,
    text:,
    channel: "whatsapp"
  )

    channel = channel.to_s.downcase

    channel = "whatsapp" unless CHANNELS.include?(channel)

    Ailog.create!(
      aicustomer_id: aicustomer_id,
      phone: phone,
      customer_name: customer_name,
      message: text,
      channel: channel,
      received_at: Time.current
    )

  rescue => e
    Rails.logger.error("[SaveAiLogJob] #{e.class}: #{e.message}")
  end
end