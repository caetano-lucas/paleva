class DropFeatures < ActiveRecord::Migration[7.2]
  def up
    drop_table :features
  end
end
