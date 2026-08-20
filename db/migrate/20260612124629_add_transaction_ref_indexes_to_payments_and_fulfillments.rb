class AddTransactionRefIndexesToPaymentsAndFulfillments < ActiveRecord::Migration[7.0]
  def change
    # -------------------------
    # Add columns (safe)
    # -------------------------
    add_column :jfulfillments, :transaction_ref, :string unless column_exists?(:jfulfillments, :transaction_ref)
    add_column :jmpayments, :transaction_ref, :string unless column_exists?(:jmpayments, :transaction_ref)

    # -------------------------
    # Add indexes (unique)
    # -------------------------
    add_index :jfulfillments, :transaction_ref, unique: true unless index_exists?(:jfulfillments, :transaction_ref)

    add_index :jmpayments, :transaction_ref, unique: true unless index_exists?(:jmpayments, :transaction_ref)
  end
end