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
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    cpf2 = CPF.generate(true).split
    
    login_as(user)
    visit root_path
    click_on 'Cadastrar novo Pedido'
    fill_in 'Nome do Cliente', with: 'Felipe Marciel'
    fill_in 'CPF', with: "#{cpf2}"
    fill_in 'E-mail', with: 'felipemarciel@exemple.com'
    click_on 'Iniciar Pedido'

    expect(page).to have_content 'Pedido iniciado com sucesso..'
    expect(page).to have_content 'Adicionar itens ao Pedido de: Felipe Marciel'
    expect(page).to have_content "Número Pedido: #{MenuItem.last}"
  end
  it 'e adiciona items ao pedido' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
    drink = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish.id) 
    dinner = Menu.create!(name: 'Jantar', restaurant: restaurant)
    lunch = Menu.create!(name: 'Almoço', restaurant: restaurant)
    MenuItem.create!(menu_itemable: dish, menu: dinner )
    cpf2 = CPF.generate(true).split
    Order.create!(client_name: 'Felipe Marciel', cpf: cpf2, phone: nil, email: 'felipemarciel@exemple.com',
                  restaurant: restaurant, status: 0)
    login_as(user)
    visit root_path
    click_on 'Cadastrar novo Pedido'
    fill_in 'Nome do Cliente', with: 'Felipe Marciel'
    fill_in 'CPF', with: "#{cpf2}"
    fill_in 'E-mail', with: 'felipemarciel@exemple.com'
    click_on 'Iniciar Pedido'
    check 'order_item[portion_ids][]'
    fill_in 'order_item[quantity][1]', with: '3'
    click_on 'Salvar Pedido'
    
    expect(page).to have_content 'Felipe Marciel'
    expect(page).to have_content 'felipemarciel@exemple.com'
    expect(page).to have_content 'Macarronada'
    expect(page).to have_content 'Meia porção - 3 pessoas'
  end
end