class Addahoy < ActiveRecord::Migration[6.0]
def up
add_index :ahoy_visits, [:visitor_token, :started_at]

  end


end
