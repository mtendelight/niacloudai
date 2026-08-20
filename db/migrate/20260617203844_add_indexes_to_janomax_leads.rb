class AddIndexesToJanomaxLeads < ActiveRecord::Migration[8.1]
  def change
    add_index :janomaxleads, :phone, unique: true unless index_exists?(:janomaxleads, :phone)

    add_index :janomaxleads, :lead_status unless index_exists?(:janomaxleads, :lead_status)

    add_index :janomaxleads, :customer_exists unless index_exists?(:janomaxleads, :customer_exists)

    add_index :janomaxleadcalls, :called_at unless index_exists?(:janomaxleadcalls, :called_at)

    add_index :janomaxleadcalls, :status unless index_exists?(:janomaxleadcalls, :status)

    add_index :janomaxleadcalls, :janomaxlead_id unless index_exists?(:janomaxleadcalls, :janomaxlead_id)
  end
end