require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario edita uma bebida ja cadastrada' do
  it 'com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
     Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alchool: false, restaurant_id: restaurant.id )
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end        
    click_on 'BebidaPrincipal'
    click_on 'Editar Bebida'
    fill_in 'Nome da bebiba', with: 'NomeBebidaTeste'
    fill_in 'Descrição', with: 'DescriçãoBebidaTeste'
    fill_in 'Possui alcool', with: 'true'
    click_on 'Salvar Bebida'
    
    expect(current_path).to eq dishes_path
    expect(page).to have_content 'NomeBebidaTeste'
    expect(page).to have_content 'DescriçãoBebidaTeste'
    expect(page).to have_content 'true'
    expect(page).to have_content 'Lista de Bebidas'
  end
end