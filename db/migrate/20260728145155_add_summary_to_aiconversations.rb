class AddSummaryToAiconversations < ActiveRecord::Migration[8.1]
  def change
    add_column :aiconversations, :summary, :text
  end
end
