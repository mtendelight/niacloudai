class CreateJmcustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :jmcustomers do |t|
      t.string :name
      t.string :phone
      t.string :location

      t.timestamps
    end
  end
end
