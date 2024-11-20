require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario ve bebidas cadastrados' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Bebidas Cadastradas'
    
  end
  it 'a partir do menu' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant, status: 'active')

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end

    expect(page).to have_content 'Lista de Bebidas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).to have_content 'A mais pedido'
    expect(page).to have_content 'Ativo'
  end

  it 'e não tem bebidas cadastradas' do
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
      click_on 'Bebidas Cadastradas'
    end
    expect(page).to have_link 'Cadastrar Nova Bebida'
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).to have_content 'Não há bebidas cadastradas'
  end

  it 'e não vê bebidas de outros restaurantes' do
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
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant_user_one )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant_user_one )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais barata', alcohol: true, restaurant: restaurant_user_two )


    login_as(user_one)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end

    expect(page).to have_content 'Lista de Bebidas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).not_to have_content 'A mais barata'
  end

  it 'e não acessa a pagina de bebidas de outros restaurantes' do
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
    
    login_as(user_one)   
    visit restaurant_drinks_path(restaurant_user_two)    
   
    expect(current_path).not_to eq restaurant_drinks_path(restaurant_user_two)
    expect(page).to have_content 'Você não tem permissão para acessar esse restaurante.'

  end
end