class SendOfferSmsToAllJob < ApplicationJob
  queue_as :default

  def perform
    sms_service = TextsmsService.new(
      api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
      partner_id: '14784',
      shortcode: 'JANOMAX'
    )

    customers = Jmcustomer.where.not(phone: [nil, ""])
    customers.find_each do |c|   # find_each handles large batches efficiently
      message = "Dear #{c.name}, exclusive Janomax offer on your next bale! Visit us today — offer valid for 2 days."
      sms_service.send_sms(c.phone, message)
    end
  end
end