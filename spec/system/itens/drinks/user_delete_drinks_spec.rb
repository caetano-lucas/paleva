require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario deleta uma bebida' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Bebidas Cadastradas'
    expect(page).not_to have_content 'Lista de Bebidas'
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
    Drink.create!(name: 'BebidaPrimaria', description: 'A mais fraca', restaurant: restaurant )
    Drink.create!(name: 'BebidaSeguntaria', description: 'super apimentada', restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    within('table') do
      click_on 'Deletar BebidaPrimaria'
    end

    expect(page).not_to have_content 'BebidaPrimaria'
    expect(page).not_to have_content 'A mais fraca'
    expect(page).to have_content 'Lista de Bebidas'
  end
end