class AddPositionToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :position, :integer, default: 0
  end
end
