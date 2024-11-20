require 'rails_helper'

describe 'usuario ve cadapio' do
  it 'se estiver logado' do 
    visit root_path

    expect(page).not_to have_link 'Cadastrar Cardápio'
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
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    drink2 = Drink.create!(name: 'Cerveja Bavária', description: '-4°', alcohol: true, restaurant: restaurant)
    menu1 = Menu.create!(name: "Café da manhã", restaurant: restaurant)
    menu = Menu.create!(name: "Almoço", restaurant: restaurant)

    login_as(user)
    visit root_path

    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'Almoço'
  end
  it 'somente do seu restaurante' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
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
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant_user_one )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant_user_one )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant_user_one )
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant_user_one)
    drink2 = Drink.create!(name: 'Cerveja Bavária', description: '-4°', alcohol: true, restaurant: restaurant_user_one)
    menu = Menu.create!(name: 'Janta', restaurant: restaurant_user_one)
    menu = Menu.create!(name: 'Almoço', restaurant: restaurant_user_two)

    login_as(user_one)
    visit root_path

    expect(page).to have_content 'Janta'
    expect(page).not_to have_content 'Almoço'
  end
  it 'e não há cardápios cadastrados' do
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

    expect(page).to have_content "Não há cardápios cadastrados para este restaurante"
  end
  it 'e não tem acesso a lista de outros restaurantes' do
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

    visit restaurant_menus_path(restaurant_user_two)
   
    expect(current_path).not_to eq restaurant_menus_path(restaurant_user_two)
    expect(page).to have_content 'Você não possui acesso a esta função'
  end
  it 'e ve as porções com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    drink2 = Drink.create!(name: 'Cerveja Bavária', description: '-4°', alcohol: true, restaurant: restaurant)
    portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    portion2 = Portion.create!(description: 'Inteira - 6 pessoas', price_whole: 79, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    dinner = Menu.create!(name: 'Jantar', restaurant: restaurant)
    lunch = Menu.create!(name: 'Almoço', restaurant: restaurant)
    MenuItem.create!(menu_itemable: dish1, menu: dinner )
    MenuItem.create!(menu_itemable: dish2, menu: dinner )

    login_as(user)
    visit root_path

    expect(page).to have_content 'Jantar'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content 'Macarrão'
    expect(page).to have_content 'Lasanha'
    expect(page).to have_content '45,99'
    expect(page).not_to have_content 'Goiabada'
  end
end