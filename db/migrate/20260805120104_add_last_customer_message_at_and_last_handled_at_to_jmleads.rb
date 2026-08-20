class AddLastCustomerMessageAtAndLastHandledAtToJmleads < ActiveRecord::Migration[8.1]
  def change
    add_column :jmleads, :last_customer_message_at, :datetime
    add_column :jmleads, :last_handled_at, :datetime
  end
end
