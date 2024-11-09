class CreateItemFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :item_features do |t|
      t.string :name
      t.belongs_to :featurable, polymorphic: true
      t.timestamps
    end
  end
end
