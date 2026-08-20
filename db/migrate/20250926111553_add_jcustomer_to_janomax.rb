class AddJcustomerToJanomax < ActiveRecord::Migration[7.1]
  def change
    add_reference :janomaxes, :jcustomer, foreign_key: true
  end
end
