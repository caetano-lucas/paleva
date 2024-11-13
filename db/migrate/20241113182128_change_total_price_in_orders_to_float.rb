class ChangeTotalPriceInOrdersToFloat < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :total_price, :float
  end
end
