class AddTrackingToJmleads < ActiveRecord::Migration[8.1]
  def change
    add_column :jmleads, :source, :string
    add_column :jmleads, :converted_at, :datetime
  end
end
