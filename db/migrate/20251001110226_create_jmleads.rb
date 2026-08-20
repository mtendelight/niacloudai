class CreateJmleads < ActiveRecord::Migration[7.2]
  def change
    create_table :jmleads do |t|
      t.string :name
      t.string :phone
      t.text :items_required
      t.string :status, default: "open"

      t.timestamps
    end
  end
end
