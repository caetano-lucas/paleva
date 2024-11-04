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
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant )
  
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
    click_on 'Salvar Prato'
    
    expect(page).to have_content 'NomePratoTeste2'
    expect(page).to have_content 'DescriçãoPratoTeste2'
    expect(page).to have_content 'Lista de Pratos'
    expect(page).not_to have_content 'PratoPrincipal'
    expect(page).not_to have_content 'O mais pedido'
  end  

  it 'e não acessa a tela de edição de pratos de outros restaurantes' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                             cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                             email: 'useronerestaurant@gmail.com',
                                             user: user_one)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    restaurant_user_two = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                                             cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                                             email: 'usertworestaurant@gmail.com',
                                             user: user_two)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant_user_one )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 5000, restaurant: restaurant_user_one )
    dish3 = Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 21300, restaurant: restaurant_user_two )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 6000, restaurant: restaurant_user_two )
    login_as(user_one)   
    visit edit_restaurant_dish_path(restaurant_user_two, dish3)    
   
    expect(current_path).not_to eq edit_restaurant_dish_path(restaurant_user_two, dish3)
    expect(page).to have_content 'Você não possui acesso a esta lista'
  end
end