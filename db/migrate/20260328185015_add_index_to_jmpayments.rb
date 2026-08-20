class AddIndexToJmpayments < ActiveRecord::Migration[8.1]
  def change
    add_index :jmpayments, :mpesa_number
   add_index :jmpayments, :transaction_ref
  end
end
