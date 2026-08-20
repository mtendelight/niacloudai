module ConversationsHelper
  def total_unread_messages(user)
    Conversation
      .where("sender_id = ? OR recipient_id = ?", user.id, user.id)
      .sum { |c| c.unread_count_for(user) }
  end
end