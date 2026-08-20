class AddLastHandledAtToJanomaxleads < ActiveRecord::Migration[8.1]
  def change
    add_column :janomaxleads, :last_handled_at, :datetime
  end
end
