# app/jobs/sms_balance_monitor_job.rb

class SmsBalanceMonitorJob
  include Sidekiq::Job

  ALERT_PHONE = "254714316282"
  THRESHOLD = 100

  def perform
    sms_service = TextsmsService.new(
      api_key: ENV.fetch("TEXTSMS_API_KEY"),
      partner_id: ENV.fetch("TEXTSMS_PARTNER_ID"),
      shortcode: "JANOMAX"
    )

    balance = sms_service.balance.to_f

    if balance < THRESHOLD && !Rails.cache.exist?("sms_balance_alert_sent")

      sms_service.send_sms(
        ALERT_PHONE,
        "⚠️ Janomax SMS balance is low (#{balance}). Please top up your SMS account."
      )

      Rails.cache.write("sms_balance_alert_sent", true, expires_in: 12.hours)

    elsif balance >= THRESHOLD

      Rails.cache.delete("sms_balance_alert_sent")

    end
  rescue => e
    Rails.logger.error("SMS Balance Monitor: #{e.message}")
  end
end