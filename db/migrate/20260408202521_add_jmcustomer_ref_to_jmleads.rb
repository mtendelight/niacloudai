class AddJmcustomerRefToJmleads < ActiveRecord::Migration[8.1]
  def change
    add_reference :jmleads, :jmcustomer, foreign_key: true
  end
end
