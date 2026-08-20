class CreateJbranchperformances < ActiveRecord::Migration[7.2]
  def change
    create_table :jbranchperformances do |t|
      t.string :branch, null: false
      t.integer :bales_sold, null: false
      t.date :record_date, null: false

      t.timestamps
    end

    add_index :jbranchperformances, [:branch, :record_date], unique: true
  end
end
