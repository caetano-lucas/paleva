require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuario busca uma bebida' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(page).not_to have_button 'Buscar-Bebida'  
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

    login_as(user)
    visit root_path

    within('header nav') do
      expect(page).to have_button 'Buscar-Bebida'
    end
  end

  it 'e encontra uma bebida por parte do nome' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedido', alcohol: true, restaurant: restaurant )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'BebidaP'
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'Bebidas encontradas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).not_to have_content 'BebidaSecundaria'
    expect(current_path).to eq search_restaurant_drinks_path(restaurant)
  end
  it 'e tem acesso a detalhes da bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedido', alcohol: true, restaurant: restaurant)
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'BebidaPrincipal'
    end
    click_on 'Buscar-Bebida'

    expect(current_path).to eq search_restaurant_drinks_path(restaurant)
   
    expect(page).to have_content 'Ativo'
  end
  it 'e tem acesso a detalhes das bebidas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    drink2 = Drink.create!(name: 'BebidaP', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    drink2.inactive!
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedido', alcohol: true, restaurant: restaurant )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'BebidaP'
    end
    click_on 'Buscar-Bebida'

    expect(current_path).to eq search_restaurant_drinks_path(restaurant)
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'Inativo'
  end

  it 'e encontra uma bebida pela descrição' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'A menos pedida'
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'A menos pedida'
    expect(page).to have_link 'Editar BebidaSecundaria'
    expect(page).not_to have_content 'BebidaPrincipal'
  end
  it 'e encontra mais de uma bebida por parte do nome' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedido', alcohol: true, restaurant: restaurant )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'Bebida'
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'Bebidas encontradas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).to have_content 'BebidaSecundaria'
  end

  
  it 'e encontra mais de uma bebida pela descrição' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'pedida'
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'A menos pedida'
    expect(page).to have_link 'Editar BebidaSecundaria'
    expect(page).to have_content 'BebidaPrincipal'
  end
  it 'e nao encontra nenhum item que está sendo buscado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'não encontrar - nome', description: 'não encontrar - descricao', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'Goiaba'
    end
    click_on 'Buscar-Bebida'

    expect(page).not_to have_content 'BebidaPrincipal'
    expect(page).not_to have_content 'BebidaSecundaria'
    expect(page).to have_content 'Nenhuma bebida encontrada'
  end
  it 'e não encontra um item que não está sendo buscado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'não encontrar - nome', description: 'não encontrar - descricao', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: 'pedida'
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'A mais pedida'
    expect(page).to have_content 'A menos pedida'
    expect(page).not_to have_content 'não encontrar - descricao'
  end
  it 'e não digita nada e clica em buscar bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id, status: 'active' )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_drink', with: ''
    end
    click_on 'Buscar-Bebida'

    expect(page).to have_content 'A mais pedida'
    expect(page).to have_content 'A menos pedida'
    expect(page).to have_content 'Ativo'
  end

  it 'e clica em cadastrar nova bebida' do
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
      fill_in 'search_drink', with: ''
    end
    click_on 'Buscar-Bebida'
    click_on 'Cadastrar Nova Bebida'

    expect(page).to have_content 'Adicione as informações da bebida'
    expect(current_path).to eq new_restaurant_drink_path(restaurant)
  end
  it 'e encontra uma bebida filtrando por características' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    ItemFeature.create!(feature: feature1, featurable: drink1)
    
    login_as(user)
    visit root_path
    click_on 'Buscar-Bebida'
    check 'feature_ids[]'
    click_button 'Filtrar'

    expect(page).to have_link 'Editar BebidaPrincipal'
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).to have_content 'BebidaPrincipal'
    expect(page).not_to have_content 'Apimentada'
    expect(current_path).to eq restaurant_drinks_path(restaurant)
  end
  it 'e não encontra um prato filtrando por características na busca' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    ItemFeature.create!(feature: feature1, featurable: drink1)
    dish1 = Dish.create!(name: 'Macarronada', description: 'Mineira', calories: 400, restaurant: restaurant )
    ItemFeature.create!(feature: feature1, featurable: dish1)

    login_as(user)
    visit root_path
    click_on 'Buscar-Bebida'
    check 'feature_ids[]'
    click_button 'Filtrar'

    expect(page).to have_link 'BebidaPrincipal'
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).not_to have_content 'Macarronada'
    expect(page).not_to have_content 'BebidaSecundaria'
    expect(current_path).to eq restaurant_drinks_path(restaurant)
  end
  it 'e não encontra um prato filtrando por características na lista de bebidas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    ItemFeature.create!(feature: feature1, featurable: drink1)
    dish1 = Dish.create!(name: 'Macarronada', description: 'Mineira', calories: 400, restaurant: restaurant )
    ItemFeature.create!(feature: feature1, featurable: dish1)

    login_as(user)
    visit root_path
    click_on 'Bebidas Cadastradas'
    check "feature_ids[]"
    click_button 'Filtrar'

    expect(page).to have_link 'BebidaPrincipal'
    expect(page).to have_content 'Lista de Bebidas'
    expect(page).not_to have_content 'Macarronada'
    expect(current_path).to eq restaurant_drinks_path(restaurant)
  end
  it 'somente se for dono do restaurante' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                             cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                             email: 'useronerestaurant@gmail.com')
    user_one.update!(restaurant_id: restaurant_user_one.id, position: :owner)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    user_two.update!(restaurant_id: restaurant_user_one.id, position: :employee)

    login_as(user_two)
    visit root_path

    expect(page).not_to have_button 'Buscar-Bebida'
  end
end