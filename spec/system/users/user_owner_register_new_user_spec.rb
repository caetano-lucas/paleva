require 'rails_helper'

describe 'um usuário dono' do
  it 'registra novos funcionários para seu restaurante' do
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
    within('form') do
      fill_in 'Nome', with: 'employee'
      fill_in 'Sobrenome', with: 'one'
      fill_in 'E-mail', with: 'employee@email.com'
      fill_in 'CPF', with: cpf2
    end
    click_button 'Salvar'

    expect(current_page).to eq  new_user_registration_path
    expect(page).to have_content 'Funcionário salvo com sucesso'
    expect(page).to have_content 'Nome: employee one'
    expect(page).to have_content 'E-mail: employee@email.com'
    expect(page).to have_content "CPF: #{cpf2}"
  end
end