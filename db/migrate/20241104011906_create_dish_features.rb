class CreateDishFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :dish_features do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true

      t.timestamps
    end
  end
end
