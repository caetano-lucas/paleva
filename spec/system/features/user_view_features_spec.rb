require 'rails_helper'

describe 'usuario vê características extras dos pratos' do  
  it 'com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Características adicionais'
    
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'exibidos pelos pratos' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    expect(page).to have_link 'Características adicionais'
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'com sucesso na busca' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    expect(page).to have_link 'Características adicionais'
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'com sucesso nos detalhes da bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    click_on 'Detalhes Macarrão'

   expect(page).to have_content 'Contém'
   expect(page).to have_content 'Glúten'
   expect(page).to have_content 'Características adicionais'
  end

  it 'com sucesso ao clicar em editar uma bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    click_on 'Editar Lasanha'

    expect(page).to have_content 'Contém'
    expect(page).to have_content 'Glúten'
    expect(page).to have_link 'Características adicionais'
  end
end