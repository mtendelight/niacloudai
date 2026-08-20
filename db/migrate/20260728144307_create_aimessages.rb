class CreateAimessages < ActiveRecord::Migration[8.1]
  def change
    create_table :aimessages do |t|
      t.references :aiconversation, foreign_key: true
      t.string :role
      t.text :content

      t.timestamps
    end
  end
end
