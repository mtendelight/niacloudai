class AddTrackingToJmcustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :jmcustomers, :acquired_from_lead, :boolean
    add_column :jmcustomers, :first_contacted_at, :datetime
  end
end
