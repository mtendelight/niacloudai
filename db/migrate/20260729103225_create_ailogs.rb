class CreateAilogs < ActiveRecord::Migration[8.1]
  def change
    create_table :ailogs do |t|
      t.references :aicustomer, foreign_key: true
      t.string :phone
      t.string :customer_name
      t.text :message
      t.datetime :received_at

      t.timestamps
    end
  end
end
