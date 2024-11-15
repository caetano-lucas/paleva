require 'rails_helper'

describe 'usuario edita porções' do
  it 'se estiver autenticado' do 

    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'

  end


  it 'das bebidas com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)
    Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant, status: 'active')
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Detalhes Coca-cola'
    click_on 'Cadastrar porção'
    fill_in 'Descrição', with: 'Lata 350ml'
    fill_in 'Preço (Parte Inteira - R$)', with: '3'
    fill_in 'Centavos', with: '99'
    click_on 'Salvar'

    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Descrição da Porção'
    expect(page).to have_content 'Lata 350ml'
    expect(page).to have_content '3,99'
  end

  it 'somente dos pratos do seu restaurante' do
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
    dish1 = Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 2000, restaurant: restaurant_user_one, status: 'active')
    dish2 = Dish.create!(name: 'PratoPrincipalTwo', description: 'O mais pedido', calories: 3000, restaurant: restaurant_user_two ,status: 'inactive')
    Portion.create!(description: 'PratoSecundario descricao1', price_whole: 3, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    Portion.create!(description: 'PratoSecundario descricao2', price_whole: 5, price_cents: 40, portionable_type: 'Dish', portionable_id: dish1.id) 
    Portion.create!(description: 'PratoPrincipalTwo descricao', price_whole: 7, price_cents: 40, portionable_type: 'Dish', portionable_id: dish2.id) 

    login_as(user_one)
    visit restaurant_dish_portions_path(restaurant_user_two, dish2)

    expect(current_path).not_to eq restaurant_dish_portions_path(restaurant_user_two, dish2)
    expect(current_path).to eq restaurant_menus_path(restaurant_user_one)
    expect(page).to have_content 'Você não possui acesso a esta lista'
  end
  
end
