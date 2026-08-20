class AddIndexToPhoneFields < ActiveRecord::Migration[8.1]
def change
  add_index :jmleads, :phone
  add_index :jmcustomers, :phone
end
end
