class AddTransactionRefToJfulfillments < ActiveRecord::Migration[8.1]
  def change
    add_column :jfulfillments, :transaction_ref, :string

    add_index :jfulfillments, :transaction_ref
  end
end