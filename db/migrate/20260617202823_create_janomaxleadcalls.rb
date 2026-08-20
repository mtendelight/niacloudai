class CreateJanomaxleadcalls < ActiveRecord::Migration[8.1]
  def change
    create_table :janomaxleadcalls do |t|
      t.references :janomaxlead, foreign_key: true
      t.datetime :called_at
      t.string :status
      t.string :agent
      t.string :direction

      t.timestamps
    end
  end
end
