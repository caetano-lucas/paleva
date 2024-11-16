class CreateEmployee < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :cpf

      t.timestamps
    end
  end
end
