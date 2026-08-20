class AddFulfillmentKeyToJfulfillments < ActiveRecord::Migration[8.0]
  def change
    add_column :jfulfillments, :fulfillment_key, :string

    add_index :jfulfillments, :fulfillment_key, unique: true
  end
end