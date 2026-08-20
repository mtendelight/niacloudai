class CreateAiknowledges < ActiveRecord::Migration[8.1]
  def change
    create_table :aiknowledges do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
