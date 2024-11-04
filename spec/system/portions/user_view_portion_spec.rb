require 'rails_helper'

describe 'usuario vê porções' do  
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
    portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    portion2 = Portion.create!(description: 'Inteira - 6 pessoas', price_whole: 79, price_cents: 99, portionable_type: 'Dish', portionable_id: dish1.id) 
    #DishPortion.create!(dish: dish1, portion1: portion1)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Detalhes Macarrão'
    
    expect(page).to have_content 'Porções Cadastradas Para este prato:'
    expect(page).to have_content 'Descrição da Porção'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content '45,99'
    expect(page).to have_content 'Inteira - 6 pessoas'
    expect(page).to have_content '79,99'
  end

  it 'das bebidas com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    drink1 = Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant, status: 'active')
    drink2 = Drink.create!(name: 'Cerveja', description: 'Schin', alcohol: true, restaurant: restaurant, status: 'active')
    Portion.create!(description: 'Lata 350 ml', price_whole: 3, price_cents: 99, portionable_type: 'Drink', portionable_id: drink1.id) 
    Portion.create!(description: 'KS', price_whole: 5, price_cents: 40, portionable_type: 'Drink', portionable_id: drink1.id) 
    Portion.create!(description: 'Latão 500ml', price_whole: 7, price_cents: 40, portionable_type: 'Drink', portionable_id: drink2.id) 

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Detalhes Coca-cola'

    expect(page).to have_content 'Porções Cadastradas Para esta bebida:'
    expect(page).to have_content 'Descrição da Porção'
    expect(page).to have_content 'Lata 350 ml'
    expect(page).to have_content '3,99'
    expect(page).to have_content 'KS'
    expect(page).to have_content '5,40'
    expect(page).not_to have_content 'Latão 500ml'
  end
end