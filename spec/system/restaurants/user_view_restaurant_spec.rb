require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario ve o seu restaurante' do
  it 'se estiver autenticado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    alphanumeric_code = SecureRandom.base36(6)
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', alphanumeric_code: alphanumeric_code,
                                    user_id: user.id)
    login_as(user)
    visit root_path
    within('nav') do
    #  click_on 'Restaurante'
    end
    #expect(current_path).to eq restaurant_path(restaurant)
  end
end