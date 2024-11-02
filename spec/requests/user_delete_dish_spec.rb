require 'rails_helper'

describe 'usuario deleta um prato' do
  it 'e não é o dono do restaurante' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                             cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                             email: 'useronerestaurant@gmail.com',
                                             user: user_one)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    restaurant_user_two = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                                             cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                                             email: 'usertworestaurant@gmail.com',
                                             user: user_two)
    dish1 = Dish.create!(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant_user_one )
    dish2 = Dish.create!(name: 'PratoSecundario', description: 'O menos pedido', calories: 6000, restaurant: restaurant_user_two )
                                         
    login_as(user_one)
    delete restaurant_dish_path(restaurant_user_two, dish2.id)   
    
    expect(response).to redirect_to(root_path)
  end
end