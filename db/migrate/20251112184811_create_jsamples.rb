class CreateJsamples < ActiveRecord::Migration[7.2]
  def change
    create_table :jsamples do |t|
      t.string :bale_name
      t.string :pieces_range
      t.text :description
      t.string :sample
      t.string :price_range

      t.timestamps
    end
  end
end
