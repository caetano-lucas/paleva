require 'rails_helper'

describe 'usuario ve pedido' do
  it 'se estiver logado' do 
    visit root_path

    expect(page).not_to have_link 'Cadastrar Cardápio'
  end
  it 'com sucesso, na lista de todos pedidos' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)
    dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
    drink = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable: dish) 
    portion2 = Portion.create!(description: 'Lata 350ml', price_whole: 3, price_cents: 99, portionable: drink) 
    dinner = Menu.create!(name: 'Jantar', restaurant: restaurant)
    MenuItem.create!(menu_itemable: dish, menu: dinner )
    MenuItem.create!(menu_itemable: drink, menu: dinner )
    cpf2 = CPF.generate(true).split
    order1 = Order.create!(client_name: 'Felipe Marciel', cpf: cpf2, phone: nil, email: 'felipemarciel@exemple.com', restaurant: restaurant)
    OrderItem.create!(portion: portion1, order: order1, quantity: 1, price: portion1.price_whole, cents: portion1.price_cents)
    OrderItem.create!(portion: portion2, order: order1, quantity: 3, price: portion2.price_whole, cents: portion2.price_cents)

    login_as(user)
    visit root_path
    click_on 'Histórico de Pedidos'
    
    expect(page).to have_content 'Felipe Marciel'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content '45,99'
    expect(page).to have_content 'Macarronada'
    expect(page).to have_content 'Lata 350ml'
    expect(page).to have_content '3,99'
    expect(page).to have_content 'Preço total'
  end
end