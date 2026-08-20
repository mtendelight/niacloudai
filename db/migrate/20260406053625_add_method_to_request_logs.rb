class AddMethodToRequestLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :request_logs, :method, :string
  end
end
