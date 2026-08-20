class CreateJfulfillments < ActiveRecord::Migration[7.2]
  def change
    create_table :jfulfillments do |t|
      t.string :name
      t.string :phone
      t.string :location
      t.text :items
      t.string :status
      t.string :feedback
      t.text :comments
      t.references :jmcustomer, foreign_key: true

      t.timestamps
    end
  end
end
