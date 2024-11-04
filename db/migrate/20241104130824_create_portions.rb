class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :description
      t.integer :price_whole
      t.integer :price_cents
      t.references :portionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
