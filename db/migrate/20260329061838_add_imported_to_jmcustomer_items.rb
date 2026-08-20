class AddImportedToJmcustomerItems < ActiveRecord::Migration[8.1]
  def change
    add_column :jmcustomer_items, :imported, :boolean, default: false, null: false
  end
end
