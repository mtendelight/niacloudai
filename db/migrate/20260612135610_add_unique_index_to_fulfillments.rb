class AddUniqueIndexToFulfillments < ActiveRecord::Migration[8.0]
  def change
    add_index :jfulfillments,
              [:jmcustomer_id, :transaction_ref],
              unique: true,
              name: "idx_fulfillments_customer_transaction"
  end
end