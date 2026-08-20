class AddChannelToAilogs < ActiveRecord::Migration[7.2]
  def change
    add_column :ailogs, :channel, :string, null: false, default: "whatsapp"
    add_index :ailogs, :channel
  end
end