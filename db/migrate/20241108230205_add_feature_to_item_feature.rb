class AddFeatureToItemFeature < ActiveRecord::Migration[7.2]
  def change
    add_reference :item_features, :feature, null: false, foreign_key: true
  end
end
