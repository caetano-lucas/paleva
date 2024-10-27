class CreateDrinks < ActiveRecord::Migration[7.2]
  def change
    create_table :drinks do |t|
      t.string :name
      t.string :description
      t.boolean :alcohol

      t.timestamps
    end
  end
end
