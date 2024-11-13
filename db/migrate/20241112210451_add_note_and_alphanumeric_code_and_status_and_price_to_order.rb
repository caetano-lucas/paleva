class AddNoteAndAlphanumericCodeAndStatusAndPriceToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :note, :string
    add_column :orders, :alphanumeric_code, :string
    add_column :orders, :status, :string
    add_column :orders, :total_price, :integer
  end
end