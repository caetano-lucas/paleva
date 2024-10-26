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
end
