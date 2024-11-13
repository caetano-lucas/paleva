class ChangeStatusInOrdersToInteger < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :status, :integer
  end
end
