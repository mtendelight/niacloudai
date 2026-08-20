class AddBlacklistToJmcustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :jmcustomers, :blacklist, :boolean, default: false, null: false
  end
end