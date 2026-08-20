class AddReplyToIdToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :reply_to_id, :integer
  end
end
