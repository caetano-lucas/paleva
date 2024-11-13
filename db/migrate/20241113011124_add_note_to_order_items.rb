class AddNoteToOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :note, :string
  end
end
