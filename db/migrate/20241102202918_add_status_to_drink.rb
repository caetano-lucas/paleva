class AddStatusToDrink < ActiveRecord::Migration[7.2]
  def change
    add_column :drinks, :status, :integer, default: 1
  end
end
