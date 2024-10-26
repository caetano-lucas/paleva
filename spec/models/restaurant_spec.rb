require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do 
    it 'deve ter um código' do      
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user_id: user.id)
      result = restaurant.valid?
      expect(result).to be true
    end
  end
end
