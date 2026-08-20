class AddDetailsToRequestLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :request_logs, :ip, :string
    add_column :request_logs, :user_id, :integer
  end
end
