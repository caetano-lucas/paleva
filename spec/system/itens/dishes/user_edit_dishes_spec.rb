require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario edita um prato já cadastrado' do
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

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    within('table') do
      click_on 'Editar PratoPrincipal'
    end
    fill_in 'Nome do Prato', with: 'NomePratoTeste2'
    fill_in 'Descrição', with: 'DescriçãoPratoTeste2'
    fill_in 'Calorias', with: '5000'
    click_button 'Salvar Prato'

    expect(page).to have_content 'NomePratoTeste2'
    expect(page).to have_content 'DescriçãoPratoTeste2'
    expect(page).to have_content '5000'
    expect(page).to have_content 'Lista de Pratos'    
    expect(page).not_to have_content 'PratoPrincipal'
    expect(page).not_to have_content 'O mais pedido'
  end
end