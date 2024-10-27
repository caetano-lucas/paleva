class AddRestaurantToDrinks < ActiveRecord::Migration[7.2]
  def change
    add_reference :drinks, :restaurant, null: false, foreign_key: true
  end
end
