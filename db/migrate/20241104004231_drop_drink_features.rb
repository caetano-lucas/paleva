class DropDrinkFeatures < ActiveRecord::Migration[7.2]
  def up
    drop_table :drink_features
  end
end
