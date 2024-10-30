require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario deleta um prato' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'
    
  end
  it 'com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 6000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    within('table') do
      click_on 'Deletar PratoPrincipal'
    end

    expect(page).not_to have_content 'NomePratoTeste2'
    expect(page).not_to have_content 'DescriçãoPratoTeste2'
    expect(page).to have_content 'Lista de Pratos'
  end
end