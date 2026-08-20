class CreateJoutputs < ActiveRecord::Migration[7.1]
  def change
    create_table :joutputs do |t|
      t.integer :year
      t.string :month
      t.integer :qty

      t.timestamps
    end
  end
end
