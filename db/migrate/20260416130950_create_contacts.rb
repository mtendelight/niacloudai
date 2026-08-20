class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :location

      t.timestamps
    end
  end
end
