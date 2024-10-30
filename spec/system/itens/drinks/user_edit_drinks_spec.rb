require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario edita uma bebida ja cadastrada' do
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
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: false, restaurant_id: restaurant.id )
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    within('table') do
      click_on 'Editar BebidaPrincipal'
    end 
    fill_in 'Nome da Bebida', with: 'NomeBebidaTeste2'
    fill_in 'Descrição', with: 'DescriçãoBebidaTeste2'
    check 'Álcool'
    click_button 'Salvar Bebida'
    
    expect(page).to have_content 'NomeBebidaTeste2'
    expect(page).to have_content 'DescriçãoBebidaTeste2'
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).not_to have_content 'BebidaPrincipal'
    expect(page).not_to have_content 'A mais pedido'
  end
end