class RemoveNoteToOrder < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :note
  end
end
