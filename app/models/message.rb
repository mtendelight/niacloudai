class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :conversation, touch: true
  belongs_to :user
  validate :prevent_duplicate_message
 mount_uploader :attachment, AttachmentUploader
 before_save :save_attachment_filename

   after_create_commit do
    broadcast_append_to(
      "conversation_#{conversation_id}",
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end

  

   def attachment_filename
    attachment.file&.filename
  end



  def attachment_content_type
    attachment.file&.content_type
  end
  validates :content, presence: true, unless: :attachment_present?

  scope :unread, -> { where(read_at: nil) }


   belongs_to :reply_to, class_name: "Message", optional: true

 after_commit :enqueue_notifications, on: :create
 after_create :create_chat_task

  private



def enqueue_notifications
  ChatNotificationJob.perform_later(id)
end

  
  def save_attachment_filename
    if attachment.present? && attachment.file.present?
      self.attachment_filename = attachment.file.original_filename
    end
  end

 def attachment_present?
    attachment.present?
  end

def create_chat_task
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
    description: content,
    status: "pending"
  )

  Task.create!(
    username: receiver.username,
    email: receiver.email,
    title: "New chat from #{user.username}",
    description: <<~TEXT,
      #{user.username} has sent you a new message.

      Message:
      #{content}

      Reply here:
      https://flow.momak.co.ke/conversations/#{conversation.id}
    TEXT
    due_date: Time.current,
    status: "pending"
  )
end


def prevent_duplicate_message
  return if content.blank?

  duplicate = Message.where(
    conversation_id: conversation_id,
    user_id: user_id,
    content: content
  )
  .where.not(id: id)
  .where("created_at >= ?", 30.seconds.ago)
  .exists?

  if duplicate
    errors.add(:base, "Duplicate message detected. Please wait before sending again.")
  end
end


end