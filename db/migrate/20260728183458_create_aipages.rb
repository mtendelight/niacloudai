class CreateAipages < ActiveRecord::Migration[8.1]
  def change
    create_table :aipages do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :content
      t.datetime :last_synced_at
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :aipages, :url, unique: true
    add_index :aipages, :active
  end
end