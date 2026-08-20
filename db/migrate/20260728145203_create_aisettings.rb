class CreateAisettings < ActiveRecord::Migration[8.1]
  def change
    create_table :aisettings do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
