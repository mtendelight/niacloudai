class CreateRequestLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :request_logs do |t|
      t.string :path
      t.float :duration
      t.integer :status

      t.timestamps
    end
  end
end
