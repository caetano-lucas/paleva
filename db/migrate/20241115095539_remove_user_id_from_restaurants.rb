class RemoveUserIdFromRestaurants < ActiveRecord::Migration[7.2]
  def change
    remove_column :restaurants, :user_id
  end
end
