require 'rails_helper'

describe 'usuario altera status do pedido' do
  it 'e prato está inativo' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                 cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                 email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish = Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant )
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Detalhes PratoPrincipal'
    click_on 'Alterar Status'

    expect(current_path).to eq restaurant_dish_path(restaurant, dish) 
    expect(page).to have_content 'Inativo'
  end
  it 'e a bebida está inativa' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                 cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                 email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: false, restaurant: restaurant )
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Detalhes BebidaPrincipal'
    click_on 'Alterar Status'

    expect(current_path).to eq restaurant_drink_path(restaurant, drink) 
    expect(page).to have_content 'Inativo'
  end
end