class CreateJmcallcomments < ActiveRecord::Migration[8.1]
  def change
    create_table :jmcallcomments do |t|
      t.references :jmcustomer, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
