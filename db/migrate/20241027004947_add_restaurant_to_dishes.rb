class AddRestaurantToDishes < ActiveRecord::Migration[7.2]
  def change
    add_reference :dishes, :restaurant, null: false, foreign_key: true
  end
end
