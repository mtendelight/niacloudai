class NotifyBlacklistedPaymentJob < ApplicationJob
  queue_as :default

  ALERT_NUMBERS = %w[
    254714316282
    254747316282
    254740919499
  ].freeze

  def perform(payment_id)
    payment = Jmpayment.includes(:jmcustomer).find_by(id: payment_id)
    return unless payment

    customer = payment.jmcustomer
    return unless customer&.blacklist?

    message = <<~SMS.squish
      🚨 BLACKLIST ALERT

      A blacklisted customer has made a payment.

      Name: #{customer.name}
      Phone: #{customer.phone}
      Amount: KES #{payment.amount}
      Ref: #{payment.transaction_ref}

      Please review the account and take appropriate action.
    SMS

    sms_service = TextsmsService.new(
      api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
      partner_id: '14784',
      shortcode: 'JANOMAX'
    )

    ALERT_NUMBERS.each do |number|
      sms_service.send_sms(number, message)
    end

    Rails.logger.info(
      "🚨 Blacklist alert sent for customer ##{customer.id}"
    )

  rescue => e
    Rails.logger.error(
      "❌ Failed blacklist alert for payment ##{payment_id}: #{e.message}"
    )
  end
end