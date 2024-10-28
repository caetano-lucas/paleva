require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuario busca um item' do
  it 'a partir do menu' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant_id: restaurant.id )
    login_as(user)
    visit root_path

    within('header nav') do
      expect(page).to have_button 'Buscar-Prato'
    end
  end

  it 'e deve estar autenticada' do
    
    visit root_path

    within('header nav') do
      expect(page).not_to have_button 'Buscar-Prato'
    end
  end

  it 'e encontra um prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )
    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'Buscar Prato', with: 'PratoPrincipal'
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'Prato encontrado'
    expect(page).to have_content 'PratoPrincipal'
    expect(page).not_to have_content 'PratoSecundario'
  end
end