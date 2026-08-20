class CreateJfaqs < ActiveRecord::Migration[8.1]
  def change
    create_table :jfaqs do |t|
      t.string :question
      t.text :answer
      t.string :category

      t.timestamps
    end
  end
end
