require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario ve pratos cadastrados para seu restaurante' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'
    
  end
  
  it 'a partir do menu' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant )
    user.update!(restaurant_id: restaurant.id, position: :owner)
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    expect(page).to have_content 'Lista de Pratos'
    expect(page).to have_content 'PratoPrincipal'
    expect(page).to have_content 'O mais pedido'
    expect(page).to have_content 'Ativo'
  end
  
  it 'e não tem pratos cadastradas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    expect(page).to have_link 'Cadastrar novo prato'
    expect(page).to have_content 'Lista de Pratos'
    expect(page).to have_content 'Não há pratos cadastrados'
  end

  it 'e não vê pratos de outros restaurantes' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                             cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                             email: 'useronerestaurant@gmail.com')
    user_one.update!(restaurant_id: restaurant_user_one.id, position: :owner)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    restaurant_user_two = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                                             cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                                             email: 'usertworestaurant@gmail.com')
    user_two.update!(restaurant_id: restaurant_user_two.id, position: :owner)
    Dish.create!(name: 'PratoPrincipalOne', description: 'O mais pedido', calories: 1000, restaurant: restaurant_user_one, status: 'active' )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant_user_one, status: 'inactive')
    Dish.create!(name: 'PratoPrincipalTwo', description: 'O mais pedido', calories: 3000, restaurant: restaurant_user_two ,status: 'inactive')


    login_as(user_one)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end

    expect(page).to have_content 'PratoPrincipal'
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'O menos pedido'
    expect(page).to have_content 'Inativo'
    expect(page).not_to have_content 'PratoPrincipalTwo'
  end

  it 'e não acessa a pagina de pratos de outros restaurantes' do
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
    login_as(user_one)   
    visit restaurant_dishes_path(restaurant_user_two)    
   
    expect(current_path).not_to eq restaurant_dishes_path(restaurant_user_two)
    expect(page).to have_content 'Você não possui acesso a esta função'
  end
end