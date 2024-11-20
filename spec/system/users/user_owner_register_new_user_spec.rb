require 'rails_helper'

describe 'um usuário dono registra novos funcionários para seu restaurante' do
  it 'com sucesso' do
    cpf = CPF.generate(true).split
    
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    cpf2 = CPF.generate(true).split

    login_as(user)
    visit root_path
    click_on 'Restaurante'
    click_on 'Pré Cadastrar Novo Funcionário'
    fill_in 'E-mail', with: 'employee@email.com'
    fill_in 'CPF', with: "#{cpf2}"
   
    click_button 'Salvar Funcionário'

    expect(current_path).to eq  restaurant_employees_path(restaurant)
    expect(page).to have_content 'Funcionário criado com sucesso.'
    expect(page).to have_content 'employee@email.com'
    expect(page).to have_content "#{cpf2}"
  end
  it 'e o funcionário faz login com sucesso' do
    cpf = CPF.generate(true).split
    
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id, position: :owner)
    cpf2 = CPF.generate(true).split
    employee = User.create!(email: 'employee@email.com',first_name: 'employee',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf2)
    employee.update!(restaurant_id: restaurant.id, position: :employee)
    login_as(employee)
    visit root_path
    click_on 'Restaurante'
    click_on 'Pré Cadastrar Novo Funcionário'

    expect(page).to have_content 'Você não possui acesso a esta função'
    expect(page).to have_content 'Novo Pedido'
  end
end