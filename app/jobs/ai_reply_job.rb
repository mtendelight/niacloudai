# app/jobs/ai_reply_job.rb

class AiReplyJob < ApplicationJob
  queue_as :default

  AI_USERNAME = "janomaxai".freeze
  HISTORY_LIMIT = 20

  def perform(message_id)
    message = Message.includes(:user, :conversation).find_by(id: message_id)
    return unless message

    conversation = message.conversation

    ai_user = User.find_by("LOWER(username) = ?", AI_USERNAME)
    return unless ai_user

    # Conversation must involve the AI
    return unless [conversation.sender_id, conversation.recipient_id].include?(ai_user.id)

    # Never reply to AI messages
    return if message.user_id == ai_user.id

    # Ignore empty messages (unless they have an attachment)
    return if message.content.blank? && message.attachment.blank?

    history = build_history(conversation)

    reply = OpenaiService.new(
      history: history,
      user_message: history.last[:content],
      current_user: message.user
    ).reply

    return if reply.blank?

    conversation.messages.create!(
      user: ai_user,
      content: reply
    )
  rescue => e
    Rails.logger.error "[AiReplyJob] #{e.class}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  private

  def build_history(conversation)
    conversation
      .messages
      .includes(:user)
      .order(created_at: :asc)
      .last(HISTORY_LIMIT)
      .map do |msg|

        content = msg.content.to_s

        if msg.attachment.present?
          filename = msg.attachment_filename.presence || "Attachment"
          content = "#{content}\n\n[Attachment: #{filename}]".strip
        end

        {
          role: msg.user.username.to_s.downcase == AI_USERNAME ? "assistant" : "user",
          content: content
        }
      end
  end
end