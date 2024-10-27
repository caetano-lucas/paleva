require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario ve bebidas cadastrados para seu restaurante' do
  it 'a partir do menu' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user_id: user.id)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant_id: restaurant.id )
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).to have_content 'A mais pedido'
  end
end