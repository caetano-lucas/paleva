require 'rails_helper'

describe 'usuario vê características extras' do
  it 'se estiver autenticado' do 

    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'

  end
  it 'com sucesso para pratos' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    _dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    _dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Características adicionais'
    
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'exibidos na lista de pratos' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    _dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    _dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)
    ItemFeature.create!(feature: feature2, featurable: dish1)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    expect(page).to have_link 'Características adicionais'
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'com sucesso na busca de pratos' do
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
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    ItemFeature.create!(feature: feature1, featurable: dish1)
    ItemFeature.create!(feature: feature2, featurable: dish2)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    expect(page).to have_link 'Características adicionais'
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'com sucesso nos detalhes de um prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    _dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    _dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    click_on 'Detalhes Macarrão'

   expect(page).to have_content 'Contém'
   expect(page).to have_content 'Glúten'
  end

  it 'com sucesso ao clicar em editar um prato' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    _dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    _dish3 = Dish.create!(name: 'Goiabada', description: 'Mineira', calories: 400, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: dish2)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Prato'
    end
    click_on 'Editar Lasanha'

    expect(page).to have_content 'Contém'
    expect(page).to have_content 'Glúten'
  end

  it 'com sucesso para bebidas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant)
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant)
                                
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: drink1)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Características adicionais'
    
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'exibidos na lista de bebidas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant)
    drink2 = Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant)
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    ItemFeature.create!(feature: feature1, featurable: drink1)
    ItemFeature.create!(feature: feature2, featurable: drink2)

    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    expect(page).to have_link 'Características adicionais'
    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
    expect(page).to have_content 'Contém'
  end
  
  it 'com sucesso na busca de bebidas' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant)
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant)
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: drink1)
    ItemFeature.create!(feature: feature2, featurable: drink1)
                                
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Bebida'
    end

    expect(page).to have_content 'Glúten'
    expect(page).to have_content 'Alto em açucar'
  end

  it 'com sucesso nos detalhes de uma bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant)
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant)
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: drink1)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Buscar-Bebida'
    end
    click_on 'Detalhes BebidaPrincipal'

   expect(page).to have_content 'Contém'
   expect(page).to have_content 'Glúten'
  end

  it 'com sucesso ao clicar em editar uma bebida' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)

    drink1 = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: true, restaurant: restaurant)
    Drink.create!(name: 'BebidaSecundaria', description: 'A menos pedida', alcohol: true, restaurant: restaurant)
    feature1 = Feature.create!(name: 'Lactose', restaurant: restaurant)
    _feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: drink1)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Editar BebidaPrincipal'

    expect(page).to have_content 'Lactose'
    expect(page).to have_content 'Adicionar característica'
  end
  it 'e não vê de outros restaurantes' do
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
    dish2 = Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant_user_two )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant_user_one)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant_user_two)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: dish1)
    _item_feature = ItemFeature.create!(feature: feature2, featurable: dish2)

    
    login_as(user_one)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end

    expect(page).to have_content 'Glúten'
    expect(page).not_to have_content 'Alto em açucar'
  end
  it 'e não vê de outros restaurantes' do
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
    drink1 = Drink.create!(name: 'cerveja', description: 'puro malte', alcohol: true, restaurant: restaurant_user_one )
    drink2 = Drink.create!(name: 'suco de laranja', description: 'natural', alcohol: false, restaurant: restaurant_user_two )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant_user_one)
    feature2 = Feature.create!(name: 'Alto em açucar', restaurant: restaurant_user_two)
    _item_feature = ItemFeature.create!(feature: feature1, featurable: drink1)
    _item_feature = ItemFeature.create!(feature: feature2, featurable: drink2)

    
    login_as(user_one)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end

    expect(page).to have_content 'Glúten'
    expect(page).not_to have_content 'Alto em açucar'
  end
end