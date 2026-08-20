class AddKnowledgeFieldsToAiknowledges < ActiveRecord::Migration[8.1]
  def change
    add_column :aiknowledges, :category, :string
    add_column :aiknowledges, :slug, :string
    add_column :aiknowledges, :url, :string
    add_column :aiknowledges, :keywords, :string
    add_column :aiknowledges, :source_type, :string
    add_column :aiknowledges, :active, :boolean, default: true, null: false

    add_index :aiknowledges, :category
    add_index :aiknowledges, :slug, unique: true
    add_index :aiknowledges, :active
  end
end