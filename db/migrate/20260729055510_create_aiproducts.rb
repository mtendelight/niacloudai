class CreateAiproducts < ActiveRecord::Migration[8.1]
  def change
    create_table :aiproducts do |t|
      t.string :bale_name, null: false
      t.text :description
      t.string :pieces_range
      t.decimal :price, precision: 12, scale: 2

      t.timestamps
    end

    add_index :aiproducts, :bale_name
  end
end