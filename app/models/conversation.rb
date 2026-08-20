class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  has_many :messages, dependent: :destroy

  validates :sender, :recipient, presence: true

  # Prevent duplicate chats
  def self.between(user1, user2)
    where(sender: user1, recipient: user2)
      .or(where(sender: user2, recipient: user1))
  end


  def unread_count_for(user)
    messages
      .where(read_at: nil)
      .where.not(user_id: user.id)
      .count
  end
end