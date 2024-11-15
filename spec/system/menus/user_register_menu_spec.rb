require 'rails_helper'

describe 'usuario cadastra um novo cardapio' do
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
    user.update!(restaurant_id: restaurant.id)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    drink2 = Drink.create!(name: 'Cerveja Bavária', description: '-4°', alcohol: true, restaurant: restaurant)
    
    login_as(user)
    visit root_path
    click_on 'Cadastrar Cardápio'
    fill_in 'Nome do cardápio', with: 'café da manhã'
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'café da manhã'
  end
  it 'com nome único, com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    drink2 = Drink.create!(name: 'Cerveja Bavária', description: '-4°', alcohol: true, restaurant: restaurant)
    menu = Menu.create!(name: 'Janta', restaurant: restaurant)

    login_as(user)
    visit root_path
    click_on 'Cadastrar Cardápio'
    fill_in 'Nome do cardápio', with: 'Janta'
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'ERRO Cardapio já cadastrado'
    expect(page).not_to have_content 'Janta'
  end
  it 'independente de outros restaurantes' do
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
    Menu.create!(name: 'Janta', restaurant: restaurant_user_one)

    login_as(user_two)
    visit root_path
    click_on 'Cadastrar Cardápio'
    fill_in 'Nome do cardápio', with: 'Janta'
    click_on 'Salvar Cardápio'

    expect(page).not_to have_content 'ERRO Cardapio já cadastrado'
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'Janta'
  end
  it 'com pratos e bebidas, mostrando as porções' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)
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
    MenuItem.create!(menu_itemable: dish2, menu: lunch )
    MenuItem.create!(menu_itemable: drink1, menu: dinner )
    MenuItem.create!(menu: dinner, menu_itemable: drink2 )

    login_as(user)
    visit root_path

    expect(page).to have_content 'Jantar'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content 'Macarrão'
    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'Cerveja Bavária'
    expect(page).to have_content 'Lasanha'
    expect(page).not_to have_content 'Goiabada'
  end
end