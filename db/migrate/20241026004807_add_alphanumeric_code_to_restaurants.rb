class AddAlphanumericCodeToRestaurants < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :alphanumeric_code, :string
  end
end
