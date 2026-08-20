class AddUserdetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :userdetails, :string
  end
end
