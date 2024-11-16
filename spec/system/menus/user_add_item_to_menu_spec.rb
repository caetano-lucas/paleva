require 'rails_helper'

describe 'usuario adiciona um item ao cardapio' do
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
    user.update!(restaurant_id: restaurant.id, position: :owner)
    Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    Dish.create!(name: 'Lasanha', description: 'Camarão com catupiry', calories: 600, restaurant: restaurant )
    Drink.create!(name: 'Coca-cola', description: 'Zero', alcohol: false, restaurant: restaurant)
    Menu.create!(name: 'Jantar', restaurant: restaurant)

    login_as(user)
    visit root_path
    click_on 'Adicionar item ao Jantar'

    expect(page).to have_content 'Jantar'
    expect(page).to have_content 'Macarrão'
    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'Lasanha'
    expect(page).not_to have_content 'Goiabada'
  end
end