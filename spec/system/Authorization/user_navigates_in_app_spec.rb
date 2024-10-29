require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario nevega pela aplicacao' do
  it 'se tiver restaurante cadastrado' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user_id: user.id)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'PaLevá'
    end

    expect(current_path).to eq root_path
  end

  it 'se tiver restaurante não estiver cadastrado' do
    cpf = CPF.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'PaLevá'
    end

    expect(current_path).to eq new_restaurant_path
  end

  it 'e é bloqueado ao tentar acessar outros restaurantes' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    cnpj2 = CNPJ.generate(true).split
    user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                            cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                            email: 'useronerestaurant@gmail.com',
                                            user_id: user_one.id)
    user_two = User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                            last_name: 'two', password: '22345abcdeF#', cpf: cpf2)
    restaurant_user_two  = Restaurant.create!(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                            cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                            email: 'usertworestaurant@gmail.com',
                            user_id: user_two.id)

    login_as(user_two)
    visit restaurant_path(restaurant_user_one)

    expect(page).to have_content('usertwo-restaurant')
    expect(page).not_to have_content('userone-restaurant')
  end
end
