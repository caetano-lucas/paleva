require 'rails_helper'

describe 'usuario cadastra uma característica' do
  it 'se estiver autenticado' do 

    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'

  end
  it 'nova com sucesso a partir da lista' do
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
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Características adicionais'
    click_on 'Cadastrar Nova característica'
    fill_in 'Nome da Característica', with: 'Glúten'
    click_on 'Salvar Característica'

    expect(page).to have_content 'Glúten'
  end
  it 'nova com sucesso a partir da busca' do
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
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    click_on 'Características adicionais'
    click_on 'Cadastrar Nova característica'

    expect(current_path).to eq new_restaurant_feature_path(restaurant)
  end

  it 'ao prato, com sucesso a partir tela de edição do prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    Feature.create!(name: 'Glúten', restaurant: restaurant)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Editar Lasanha'
    check "feature_ids[]"
    click_on 'Salvar Prato'
    click_on 'Editar Lasanha'

    expect(page).to have_content 'Contém: Glúten'
  end
   it 'ao prato, com sucesso a partir tela de edição do prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    Feature.create!(name: 'Glúten', restaurant: restaurant)
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Editar Lasanha'
    check "feature_ids[]"
    click_on 'Salvar Prato'
    click_on 'Editar Lasanha'

    expect(page).to have_content 'Contém: Glúten'
  end

  
  it 'sem sucesso a para outros restaurantes' do
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
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant_user_one )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant_user_one )
    dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant_user_one )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant_user_one)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant_user_one)
    Feature.create!(name: 'Apimentado', restaurant: restaurant_user_one)
    item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)

    
    login_as(user_one)
    visit new_restaurant_feature_path(restaurant_user_two)

    expect(current_path).not_to eq new_restaurant_feature_path(restaurant_user_two)
    expect(current_path).to eq restaurant_menus_path(restaurant_user_one)
    expect(page).to have_content "Você não possui acesso a esta função"
  end
end