class AddWhatsappStatusToContacts < ActiveRecord::Migration[8.1]
  def change
    add_column :contacts, :whatsapp_status, :string
    add_column :contacts, :whatsapp_message_id, :string
  end
end
