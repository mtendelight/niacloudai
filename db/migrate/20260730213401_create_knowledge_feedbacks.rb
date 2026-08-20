class CreateKnowledgeFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :knowledge_feedbacks do |t|
      t.string :title
      t.string :feedback_type
      t.text :question
      t.text :recommendation
      t.string :priority, default: "medium"
      t.string :source, default: "AI"
      t.string :status, default: "pending"
      t.integer :occurrences, default: 1

      t.timestamps
    end

    add_index :knowledge_feedbacks,
              [:title, :feedback_type],
              unique: true
  end
end