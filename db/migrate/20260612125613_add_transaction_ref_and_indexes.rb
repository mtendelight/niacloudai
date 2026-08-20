class AddTransactionRefAndIndexes < ActiveRecord::Migration[8.1]
   def change
    add_column :jfulfillments, :transaction_ref, :string unless column_exists?(:jfulfillments, :transaction_ref)
    add_column :jmpayments, :transaction_ref, :string unless column_exists?(:jmpayments, :transaction_ref)

    # Clean old duplicates BEFORE adding index (important for safety)
    remove_index :jfulfillments, :transaction_ref if index_exists?(:jfulfillments, :transaction_ref)
    remove_index :jmpayments, :transaction_ref if index_exists?(:jmpayments, :transaction_ref)

    add_index :jfulfillments, :transaction_ref, unique: true
    add_index :jmpayments, :transaction_ref, unique: true
  end
end
