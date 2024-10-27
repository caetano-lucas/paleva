require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario edita um prato já cadastrado' do
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
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end    
    click_on 'PratoPrincipal'
    click_on 'Editar Prato'
    fill_in 'Nome do Prato', with: 'NomePratoTeste2'
    fill_in 'Descrição', with: 'DescriçãoPratoTeste2'
    fill_in 'Calorias', with: 'Quantidade de calorias do PratoTeste1'
    click_on 'Salvar Prato'
    
    expect(current_path).to eq dishes_path
    expect(page).to have_content 'NomePratoTest2'
    expect(page).to have_content 'DescriçãoPratoTeste2'
    expect(page).to have_content 'Quantidade de calorias do PratoTeste1'
    expect(page).to have_content 'Lista de Pratos'
  end
end