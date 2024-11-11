class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :client_name
      t.string :cpf
      t.string :phone
      t.string :email
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
