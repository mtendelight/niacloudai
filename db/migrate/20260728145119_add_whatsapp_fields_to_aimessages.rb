class AddWhatsappFieldsToAimessages < ActiveRecord::Migration[8.0]
  def change
    add_column :aimessages, :whatsapp_message_id, :string
    add_column :aimessages, :phone, :string
    add_column :aimessages, :message_type, :string
    add_column :aimessages, :status, :string

    add_index :aimessages, :whatsapp_message_id, unique: true
  end
end