class AddLowBalanceAlertSentToMAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :m_accounts, :low_balance_alert_sent,
               :boolean,
               default: false,
               null: false
  end
end