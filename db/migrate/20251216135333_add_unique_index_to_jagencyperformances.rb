class AddUniqueIndexToJagencyperformances < ActiveRecord::Migration[7.0]
  def change
    add_index :jagencyperformances, [:agent, :record_date], unique: true, name: "index_jagencyperformances_on_agent_and_record_date"
  end
end
