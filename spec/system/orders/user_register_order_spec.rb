require 'rails_helper'

describe 'usuario cadastra um novo pedido' do
  it 'se estiver logado' do 
    visit root_path

    expect(page).not_to have_content 'Novo Pedido'
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
    cpf2 = CPF.generate(true).split
    
    login_as(user)
    visit root_path
    click_on 'Novo Pedido'
    fill_in 'Nome do cliente', with: 'Felipe Marciel'
    fill_in 'CPF', with: "#{cpf2}"
    fill_in 'E-mail', with: 'felipemarciel@exemple.com'
    click_on 'Iniciar Pedido'

    expect(page).to have_content 'Pedido iniciado com sucesso..'
    expect(page).to have_content 'Felipe Marciel'
    expect(page).to have_content 'felipemarciel@exemple.com'
    expect(page).to have_content "#{cpf2}"
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
    dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
    drink = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish.id) 
    portion2 = Portion.create!(description: '2 litros - zero', price_whole: 10, price_cents: 99, portionable_type: 'Drink', portionable_id: drink.id) 
    dinner = Menu.create!(name: 'Jantar', restaurant: restaurant)
    lunch = Menu.create!(name: 'Almoço', restaurant: restaurant)
    MenuItem.create!(menu_itemable: dish, menu: dinner )
    MenuItem.create!(menu_itemable: dish, menu: lunch )
    cpf2 = CPF.generate(true).split
    
    login_as(user)
    visit root_path
    click_on 'Novo Pedido'
    fill_in 'Nome do cliente', with: 'Felipe Marciel'
    fill_in 'CPF', with: "#{cpf2}"
    fill_in 'E-mail', with: 'felipemarciel@exemple.com'
    click_on 'Iniciar Pedido'
    expect(page).to have_content 'Felipe Marciel'
    expect(page).to have_content 'felipemarciel@exemple.com'
    expect(page).to have_content "#{cpf2}"
  end
end