class CreateCampaignLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_logs do |t|
      t.string :phone
      t.string :name
      t.string :status
      t.string :message_id

      t.timestamps
    end
  end
end
