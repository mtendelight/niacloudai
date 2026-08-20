class AddErrorMessageToCampaignLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :campaign_logs, :error_message, :text
  end
end
