require 'rails_helper'

describe 'usuario registra porções' do
  it 'se estiver autenticado' do 

    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'

  end
  it 'dos pratos com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Detalhes Macarrão'
    click_on 'Cadastrar porção'
    fill_in 'Descrição', with: 'Meia porção - 3 pessoas'
    fill_in 'Preço (Parte Inteira - R$)', with: '45'
    fill_in 'Centavos', with: '99'
    click_on 'Salvar'

    expect(page).to have_content 'Porções Cadastradas Para este prato:'
    expect(page).to have_content 'Descrição da Porção'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content '45,99'
  end
  it 'somente dos pratos do seu restaurante' do
    cpf = CPF.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)    
    cnpj = CNPJ.generate(true).split
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user_one)

    cpf2 = CPF.generate(true).split
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    cnpj2 = CNPJ.generate(true).split
    restaurant_user_two = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                                            cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                                            email: 'usertworestaurant@gmail.com',
                                            user: user_two)
    dish1 = Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant, status: 'active')
    dish2 = Dish.create!(name: 'PratoPrincipalTwo', description: 'O mais pedido', calories: 3000, restaurant: restaurant_user_two ,status: 'inactive')
    Portion.create!(description: 'PratoSecundario descricao1', price_whole: 3, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    Portion.create!(description: 'PratoSecundario descricao2', price_whole: 5, price_cents: 40, portionable_type: 'Dish', portionable_id: dish1.id) 
    Portion.create!(description: 'PratoPrincipalTwo descricao', price_whole: 7, price_cents: 40, portionable_type: 'Dish', portionable_id: dish2.id) 

    login_as(user_one)
    visit restaurant_dish_portions_path(restaurant_user_two, dish2)

    expect(current_path).not_to eq restaurant_dish_portions_path(restaurant_user_two, dish2)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esta lista'
  end
  
end
