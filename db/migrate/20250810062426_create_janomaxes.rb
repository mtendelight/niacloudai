class CreateJanomaxes < ActiveRecord::Migration[7.1]
  def change
    create_table :janomaxes do |t|
      t.string :item_name
      t.text :item_description
      t.string :pieces
      t.string :sample

      t.timestamps
    end
  end
end
