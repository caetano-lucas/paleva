require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuario busca um prato' do
  it 'se estiver autenticado' do 
    
    visit root_path
    
    expect(page).not_to have_button 'Buscar-Prato'
  end

  it 'a partir do menu' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
                                    
    login_as(user)
    visit root_path

    within('header nav') do
      expect(page).to have_button 'Buscar-Prato'
    end
  end

  it 'e encontra um prato por parte do nome' do
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
    Dish.create!(name: 'não encontrar - nome', description: 'não encontrar - descricao', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'Prato'
    end
    click_on 'Buscar-Prato'
    expect(page).to have_link 'Editar PratoPrincipal'
    expect(page).to have_content 'Pratos encontrados'
    expect(page).to have_content 'PratoPrincipal'
    expect(current_path).to eq search_restaurant_dishes_path(restaurant)
  end

  it 'e tem acesso a detalhes do prato' do
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
      fill_in 'search_dish', with: 'PratoPrincipal'
    end
    click_on 'Buscar-Prato'

    expect(current_path).to eq search_restaurant_dishes_path(restaurant)
   
    expect(page).to have_content 'Ativo'
  end

  it 'e tem acesso a detalhes dos pratos' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    drink1 = Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    drink2 = Dish.create!(name: 'PratoP', description: 'O menos pedido', calories: 2000, restaurant: restaurant )
    drink2.inactive!
    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'PratoP'
    end
    click_on 'Buscar-Prato'

    expect(current_path).to eq search_restaurant_dishes_path(restaurant)
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'Inativo'
  end


  it 'e encontra um prato pela descrição' do
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
      fill_in 'search_dish', with: 'O menos pedido'
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'O menos pedido'
    expect(page).to have_link 'PratoSecundario'
    expect(page).not_to have_content 'PratoPrincipal'
  end

  it 'e encontra mais de uma prato por parte do nome' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant)
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedido', alcohol: true, restaurant: restaurant )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'Prato'
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'Pratos encontrados'
    expect(page).to have_content 'PratoPrincipal'
    expect(page).to have_content 'PratoSecundario'
  end

  
  it 'e encontra mais de uma prato pela descrição' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'pedido'
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'O mais pedido'
    expect(page).to have_link 'Editar PratoSecundario'
    expect(page).to have_content 'PratoPrincipal'
  end
  it 'e nao encontra nenhum prato que está sendo buscado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'não encontrar - nome', description: 'não encontrar - descricao', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'Goiaba'
    end
    click_on 'Buscar-Prato'

    expect(page).not_to have_content 'O mais pedido'
    expect(page).not_to have_content 'PratoSecundario'
    expect(page).to have_content 'Nenhum prato encontrado'
  end
  it 'e não encontra um prato que não está sendo buscado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedida', alcohol: true, restaurant_id: restaurant.id )
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant_id: restaurant.id )
    Dish.create!(name: 'não encontrar - nome', description: 'não encontrar - descricao', calories: 20, restaurant_id: restaurant.id )
    Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant_id: restaurant.id )

    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: 'pedido'
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'O mais pedido'
    expect(page).to have_content 'O menos pedido'
    expect(page).not_to have_content 'não encontrar - descricao'
  end

  it 'e nao digita nada e clica em buscar prato' do
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
      fill_in 'search_dish', with: ''
    end
    click_on 'Buscar-Prato'

    expect(page).to have_content 'O menos pedido'
    expect(page).to have_link 'PratoSecundario'
    expect(page).to have_content 'PratoPrincipal'
  end
  it 'e clica em cadastrar novo prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
                                    
    login_as(user)
    visit root_path
    within('nav') do
      fill_in 'search_dish', with: ''
    end
    click_on 'Buscar-Prato'
    click_on 'Cadastrar novo prato'

    expect(page).to have_content 'Adicione as informações do prato'
    expect(current_path).to eq new_restaurant_dish_path(restaurant)
  end
end