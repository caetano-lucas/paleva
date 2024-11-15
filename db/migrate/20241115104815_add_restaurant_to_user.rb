class AddRestaurantToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :restaurant, foreign_key: true, null: true
  end
end
