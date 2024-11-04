require 'rails_helper'

describe 'usuario cadastra uma característica' do
  it 'com sucesso a partir da lista' do
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
    click_on 'Cadastrar nova característica'
    fill_in 'Nome da característica', with: 'Glúten'
    click_on 'Salvar Característica'

    expect(page).to have_content 'Glúten'
  end
  it 'com sucesso a partir da busca' do
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
    click_on 'Características adicionais'
    click_on 'Cadastrar nova característica'

    expect(current_path).to eq new_restaurant_feature_path(restaurant)
  end

  it 'com sucesso a partir tela de edição do prato' do
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
    click_on 'Editar Lasanha'
    click_on 'Adicionar característica'
    select 'Glúten', from: 'Característica'
    click_on 'Salvar'
    click_on 'Salvar Prato'

    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
    expect(page).to have_content 'Lasanha'
    expect(page).to have_content 'Goiabada'
  end

  it 'com sucesso a partir tela de cadastro do prato' do
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
    Feature.create!(name: 'Apimentado', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    DishFeature.create!(dish: dish2, feature: feature1)
    DishFeature.create!(dish: dish3, feature: feature2)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Cadastrar novo prato'
    fill_in 'Nome do Prato', with: 'NomePratoTeste'
    fill_in 'Descrição', with: 'DescriçãoPratoTeste'
    fill_in 'Calorias', with: 'Quantidade de calorias do PratoTeste1'
    click_on 'Salvar Prato'
    click_on 'Adicionar característica'
    select 'Glúten', from: 'Característica'
    click_on 'Salvar'
    click_on 'Salvar Prato'

    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'NomePratoTeste'
    expect(page).to have_content 'DescriçãoPratoTeste'
    expect(page).to have_content 'Goiabada'
  end
end