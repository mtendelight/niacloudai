class ChatTaskJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find_by(id: message_id)
    return unless message

    conversation = message.conversation
    user = message.user

    receiver =
      if conversation.sender == user
        conversation.recipient
      else
        conversation.sender
      end

    # Only create task for chats from veroh -> mtendem
    return unless user.username.downcase == "veroh"
    return unless receiver.username.downcase == "mtendem"

    # Prevent duplicate tasks
    return if Task.exists?(
      username: receiver.username,
      title: "New chat from #{user.username}",
      description: message.content,
      status: "pending"
    )

    Task.create!(
      username: receiver.username,
      email: receiver.email,
      title: "New chat from #{user.username}",
      description: <<~TEXT,
        #{user.username} has sent you a new message.

        Message:
        #{message.content}

        Reply here:
        https://flow.momak.co.ke/conversations/#{conversation.id}
      TEXT
      due_date: Time.current,
      status: "pending"
    )
  rescue => e
    Rails.logger.error "ChatTaskJob failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end