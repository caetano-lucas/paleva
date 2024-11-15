class RemoveUserToRestaurant < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :restaurants, to_table: :users
  end
end
