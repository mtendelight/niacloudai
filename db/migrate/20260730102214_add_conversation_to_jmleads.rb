class AddConversationToJmleads < ActiveRecord::Migration[8.1]
  def change
    add_column :jmleads, :conversation, :text
  end
end
