class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.integer :user_id
      t.string :device
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip

      t.timestamps
    end
  end
end
