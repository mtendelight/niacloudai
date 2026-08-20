# app/services/messenger_service.rb

class MessengerService
  include HTTParty

  base_uri "https://graph.facebook.com/v23.0"

  def self.send_message(psid, text)
    response = post(
      "/me/messages",
      headers: {
        "Authorization" => "Bearer #{ENV.fetch("FACEBOOK_PAGE_ACCESS_TOKEN")}",
        "Content-Type"  => "application/json"
      },
      body: {
        recipient: {
          id: psid
        },
        message: {
          text: text.truncate(2000)
        }
      }.to_json
    )

    unless response.success?
      Rails.logger.error(
        "Messenger Error: #{response.code} #{response.body}"
      )
    end

    response
  end
end