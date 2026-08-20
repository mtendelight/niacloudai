class ChatMailer < ApplicationMailer
  default from: "chat@momakgroup.co.ke"

  def new_message_notification(emails, staff_name, sender_name, message)
    @staff_name = staff_name
    @sender_name = sender_name
    @message = message

    mail(
      to: emails,
      subject: "📩 New Momak ERP Chat Message"
    )
  end
end