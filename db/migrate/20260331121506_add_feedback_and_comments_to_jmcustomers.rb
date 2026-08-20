class AddFeedbackAndCommentsToJmcustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :jmcustomers, :feedback, :string
    add_column :jmcustomers, :comments, :text
  end
end
