class CreateAicustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :aicustomers do |t|
      t.string :phone
      t.string :name

      t.timestamps
    end
  end
end
