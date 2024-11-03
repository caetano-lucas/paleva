require 'rails_helper'

describe 'usuario altera status do pedido' do
  it 'e bebida está inativa' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    drink = Drink.create!(name: 'BebidaPrincipal', description: 'A mais pedido', alcohol: false, restaurant: restaurant )
    
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Detalhes BebidaPrincipal'
    click_on 'Alterar Status'

    expect(current_path).to eq restaurant_drink_path(restaurant, drink) 
    expect(page).to have_content 'Inativo'
  end

  it 'e bebida está ativa' do
    
  end
end