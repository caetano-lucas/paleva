class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :trade_name
      t.string :legal_name
      t.string :cnpj
      t.string :address
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
