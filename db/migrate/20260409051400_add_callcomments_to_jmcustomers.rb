class AddCallcommentsToJmcustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :jmcustomers, :callcomments, :text
  end
end
