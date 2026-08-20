class CreateAiconversations < ActiveRecord::Migration[8.1]
  def change
    create_table :aiconversations do |t|
      t.references :aicustomer, foreign_key: true

      t.timestamps
    end
  end
end
