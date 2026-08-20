class CreateJanomaxOutboundCalls < ActiveRecord::Migration[8.1]
  def change
    create_table :janomax_outbound_calls do |t|
      t.references :janomaxlead, foreign_key: true
      t.datetime :called_at
      t.string :status
      t.string :agent
      t.string :direction
      t.string :phone

      t.timestamps
    end
  end
end
