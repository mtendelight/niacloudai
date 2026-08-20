class Jmpayment < ApplicationRecord
    belongs_to :jmcustomer, touch: true
  validates :transaction_ref, uniqueness: true
  belongs_to :agent, class_name: "Dsa", optional: true

  before_save :normalize_phone

  validates :amount, presence: true

  after_create :process_payment
  after_create_commit :notify_blacklisted_customer

  after_create :award_points
  #after_commit :touch_parent, on: [:create, :update, :destroy]

  private

  def process_payment
    send_sms_notification
  end

  def notify_blacklisted_customer
  NotifyBlacklistedPaymentJob.perform_later(id)
end

  def send_sms_notification
    customer = jmcustomer
    return unless customer&.phone.present?

    first_name = customer.name.to_s.strip.split(' ').first

    message = "Dear #{first_name}, we have received your payment. Thank you for choosing Janomax Premium Bales!"

   sms_service = TextsmsService.new(
    api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
    partner_id: '14784',
    shortcode: 'JANOMAX'
  )


    response = sms_service.send_sms(customer.phone, message)

    Rails.logger.info("💬 Payment SMS sent for Jmcustomer##{customer.id}: #{response}")
  rescue => e
    Rails.logger.error("❌ Payment SMS failed for Jmcustomer##{customer.id}: #{e.message}")
  end


    def award_points
    jmcustomer.increment!(:points, 150)
  end

  #def touch_parent
   # return unless jmcustomer.present? && persisted?
    #jmcustomer.touch
  #end

  def normalize_phone
    return if mpesa_number.blank?

    # remove 254 and replace with 0
    if mpesa_number.start_with?("254")
      self.mpesa_number = "0" + mpesa_number[3..]
    end
  end
end