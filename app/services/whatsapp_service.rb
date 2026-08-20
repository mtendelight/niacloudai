class WhatsappService

  include HTTParty

  base_uri "https://graph.facebook.com/v23.0"


  def self.send_message(phone, text)

    response = post(
      "/#{ENV.fetch("WHATSAPP_PHONE_NUMBER_ID")}/messages",
      headers: {
        "Authorization" =>
          "Bearer #{ENV.fetch("WHATSAPP_TOKEN")}",
        "Content-Type" =>
          "application/json"
      },
      body: {
        messaging_product: "whatsapp",
        to: phone,
        type: "text",
        text: {
          preview_url: false,
          body: text.truncate(4000)
        }
      }.to_json
    )


    unless response.success?
      Rails.logger.error(
        "WhatsApp Error: #{response.body}"
      )
    end


    response

  end

end