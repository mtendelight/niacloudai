class FixConversationsStructure < ActiveRecord::Migration[7.0]
  def change
    # Remove old user reference if exists
    remove_reference :conversations, :user, foreign_key: true rescue nil

    # Add sender & recipient safely
    add_reference :conversations, :sender, foreign_key: { to_table: :users } unless column_exists?(:conversations, :sender_id)
    add_reference :conversations, :recipient, foreign_key: { to_table: :users } unless column_exists?(:conversations, :recipient_id)
  end
end