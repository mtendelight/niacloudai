class AddImportedToJmcustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :jmcustomers, :imported, :boolean
  end
end
