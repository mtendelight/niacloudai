class AddJmcustomerToJanomaxes < ActiveRecord::Migration[7.2]
  def change
    add_reference :janomaxes, :jmcustomer, foreign_key: true
  end
end
