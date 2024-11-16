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
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: false, restaurant: restaurant )
    
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
  it 'e não acessa a tela de edição de bebidas de outros restaurantes' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                             cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                             email: 'useronerestaurant@gmail.com')
    user_one.update!(restaurant_id: restaurant_user_one.id)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    restaurant_user_two = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                                             cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                                             email: 'usertworestaurant@gmail.com')
    user_two.update!(restaurant_id: restaurant_user_two.id)

    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: false, restaurant: restaurant_user_one )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: false, restaurant: restaurant_user_one )
    drink3 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: false, restaurant: restaurant_user_two )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant_user_two )

    login_as(user_one)   
    visit edit_restaurant_drink_path(restaurant_user_two, drink3)    
   
    expect(current_path).not_to eq edit_restaurant_drink_path(restaurant_user_two, drink3)
    expect(page).to have_content 'Você não possui acesso a esta lista'
  end
end

