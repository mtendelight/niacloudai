class CreateJanomaxleads < ActiveRecord::Migration[8.1]
  def change
    create_table :janomaxleads do |t|
      t.string :phone
      t.string :last_status
      t.integer :calls_count
      t.string :lead_status
      t.text :comments
      t.boolean :customer_exists
      t.datetime :last_called_at
      t.references :jmcustomer, foreign_key: true

      t.timestamps
    end
  end
end
