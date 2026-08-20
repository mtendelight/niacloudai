class CreateJmcustomerItems < ActiveRecord::Migration[7.2]
  def change
    create_table :jmcustomer_items do |t|
      t.references :jmcustomer, foreign_key: true
      t.references :janomax, foreign_key: true

      t.timestamps
    end
  end
end
