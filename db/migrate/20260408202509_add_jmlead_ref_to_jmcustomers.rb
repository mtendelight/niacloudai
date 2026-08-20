class AddJmleadRefToJmcustomers < ActiveRecord::Migration[8.1]
  def change
    add_reference :jmcustomers, :jmlead, foreign_key: true
  end
end
