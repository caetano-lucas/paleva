require 'rails_helper'

describe 'usuario cadastra novo horário' do
  it 'se estiver autenticado' do 

    visit root_path

    expect(current_path).not_to have_link 'Horários Cadastrados'

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
    OperatingHour.create!(day: 'sexta-feira', open_time: "2000-01-01 12:13:00",
                                                  close_time: "2000-01-01 12:32:00", closed: 0, restaurant: restaurant)
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Horários Cadastrados'
    end
    click_on "Novo Horário"

    select 'segunda-feira', from: 'operating_hour_day'
    select '13', from: 'operating_hour_open_time_4i'
    select '09', from: 'operating_hour_open_time_5i'
    select '21', from: 'operating_hour_close_time_4i'
    select '02', from: 'operating_hour_close_time_5i'

    click_button 'Salvar'

    expect(page).to have_content("Horário de funcionamento criado com sucesso")
    expect(page).to have_content("Segunda-feira")
    expect(page).to have_content("13:09")
    expect(page).to have_content("21:02")
  end

  it 'sem sucesso se data fechamento for menor que abertura' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    OperatingHour.create!(day: 'sexta-feira', open_time: "2000-01-01 12:13:00",
                                                  close_time: "2000-01-01 12:32:00", closed: 0, restaurant: restaurant)
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Horários Cadastrados'
    end
    click_on "Novo Horário"

    select 'segunda-feira', from: 'operating_hour_day'
    select '21', from: 'operating_hour_open_time_4i'
    select '09', from: 'operating_hour_open_time_5i'
    select '13', from: 'operating_hour_close_time_4i'
    select '02', from: 'operating_hour_close_time_5i'

    click_button 'Salvar'

    expect(page).to have_content("Horário de Abertura deve ser menor que o de fechamento")
    expect(page).not_to have_content("Segunda-feira")
    expect(page).not_to have_content("13:02")
    expect(page).not_to have_content("21:09")
  end

  
  it 'somente do seu restaurante' do
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
    OperatingHour.create!(day: 'sexta-feira', open_time: "2000-01-01 12:13:00",
                                                  close_time: "2000-01-01 12:32:00", closed: 0, restaurant: restaurant_user_one)
    OperatingHour.create!(day: 'quinta-feira', open_time: "2000-01-01 17:24:00",
                                                 close_time: "2000-01-01 18:42:00", closed: 0, restaurant: restaurant_user_two)
    
    login_as(user_one)
    visit restaurant_operating_hours_path(restaurant_user_two)

    expect(current_path).not_to eq restaurant_operating_hours_path(restaurant_user_two)
    expect(current_path).to eq restaurant_menus_path(restaurant_user_one)
    expect(page).to have_content 'Você não possui acesso a esta lista'
    expect(page).not_to have_content 'quinta-feira'
  end

  it 'e ve mensagem, se não houver horários cadastrados' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Horários Cadastrados'
    end
    expect(page).to have_content "Não há horários Cadastrados"
  end
end