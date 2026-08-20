class AddSellingPriceToJanomaxes < ActiveRecord::Migration[7.1]
  def change
    add_column :janomaxes, :selling_price, :integer
  end
end
