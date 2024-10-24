class ChangeCpfTypeInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :cpf, :string
  end
end
