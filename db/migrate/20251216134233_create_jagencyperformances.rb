class CreateJagencyperformances < ActiveRecord::Migration[7.2]
  def change
    create_table :jagencyperformances do |t|
      t.string :agent
      t.integer :bales_sold
      t.date :record_date

      t.timestamps
    end
    add_index :jagencyperformances, :record_date, unique: true
  end
end
