class RemoveUniqueIndexFromJfulfillmentsTransactionRef < ActiveRecord::Migration[8.0]
  def change
    remove_index :jfulfillments, name: "index_jfulfillments_on_transaction_ref"
  end
end