class RemoveUniqueIndexFromJagencyperformances < ActiveRecord::Migration[7.2]
  def change
    remove_index :jagencyperformances, :record_date if index_exists?(:jagencyperformances, :record_date)
  end
end
