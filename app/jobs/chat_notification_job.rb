class ChatNotificationJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find_by(id: message_id)
    return unless message

    conversation = message.conversation

    staff = {
      "mtendem" => {
        phone: "254714316282",
        emails: [
          "info@momak.co.ke",
          "moses.mtende@gmail.com"
        ]
      },
      "carol" => {
        phone: "254708425968",
        emails: ["carol@momakgroup.co.ke"]
      },
      "eunice" => {
        phone: "254745673055",
        emails: ["eunice@momakgroup.co.ke"]
      },
      "vero" => {
        phone: "254797441149",
        emails: ["veronica@momakgroup.co.ke"]
      },
      "veroh" => {
        phone: "254797441149",
        emails: ["veronica@momakgroup.co.ke"]
      },

        "angela" => {
        phone: "254718615534",
        emails: ["angela@momakgroup.co.ke"]
      }

    }

    receiver =
      if conversation.sender == message.user
        conversation.recipient
      else
        conversation.sender
      end

    username = receiver.username.downcase

    return unless staff.key?(username)

    recipient = staff[username]

    sms = <<~MSG
📩 NEW CHAT ALERT

Hello #{username.titleize},

You have a new chat message.

👤 From: #{message.user.username}

💬 #{message.content}

Open Flow to reply:
https://flow.momak.co.ke/conversations
MSG

    TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    ).send_sms(recipient[:phone], sms)

    ChatMailer.new_message_notification(
      recipient[:emails],
      username.titleize,
      message.user.username,
      message.content
    ).deliver_later
  end
end