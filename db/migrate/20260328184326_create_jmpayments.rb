class CreateJmpayments < ActiveRecord::Migration[8.1]
  def change
    create_table :jmpayments do |t|
      t.references :jmcustomer, foreign_key: true
      t.date :date
      t.string :transaction_ref
      t.string :name
      t.string :mpesa_code
      t.string :mpesa_number
      t.decimal :amount

      t.timestamps
    end
  end
end
