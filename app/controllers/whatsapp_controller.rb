class WhatsappController < ApplicationController

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token


  def verify

    if params["hub.verify_token"] ==
       ENV["WHATSAPP_VERIFY_TOKEN"]

      render plain:
        params["hub.challenge"]

    else

      head :forbidden

    end

  end


def receive
  payload = params.to_unsafe_h.deep_stringify_keys

  Rails.logger.info "========== WEBHOOK RECEIVED =========="
  Rails.logger.info payload.inspect

  case payload["object"]
  when "whatsapp_business_account"
    Rails.logger.info "WhatsApp event"
    ProcessWhatsappMessageJob.perform_later(payload)

  when "page"
    Rails.logger.info "Messenger event"
    ProcessMessengerMessageJob.perform_later(payload)

  else
    Rails.logger.info "Unknown object #{payload['object']}"
  end

  head :ok
end

end