require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário registra um restaurante' do
  it 'se estiver autenticado' do 
    
  end
  it 'com sucesso' do
    cpf = CPF.generate(true).strip
    cnpj = CNPJ.generate(true)
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    
    login_as(user)
    visit root_path
    
    fill_in 'Nome Fantasia', with: 'NomeFantasiaTeste'
    fill_in 'Razão Social', with: 'RazãoSocialTeste LTDA'
    fill_in 'Telefone', with: '11123121211'
    fill_in 'E-mail', with: 'eras@email.com'
    fill_in 'Endereço', with: 'Rua do restauranteTeste, número: 200'
      fill_in 'CNPJ', with: cnpj
      click_on 'Salvar Restaurante'
      
      expect(page).to have_content 'Restaurante cadastrado com sucesso'
  end

  it 'com um cnpj único' do
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
    restaurant_user_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                            cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                            email: 'usertworestaurant@gmail.com',
                            user_id: user_two.id)

    restaurant_user_two.save!
    
    expect(restaurant_user_two.cnpj).not_to eq restaurant_user_one.cnpj
  end

  it 'com um código de acesso único' do
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
    restaurant_user_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant LTDA2',
                            cnpj: cnpj2, address: 'Restaurant street, 3', phone: '33456789102',
                            email: 'usertworestaurant@gmail.com',
                            user_id: user_two.id)

    restaurant_user_two.save!
    expect(restaurant_user_two.alphanumeric_code).not_to eq restaurant_user_one.alphanumeric_code
  end
    
  it 'sem sucesso' do
    cpf = CPF.generate(true).strip
    cnpj = CNPJ.generate(true)

    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'userone'
      fill_in 'Sobrenome', with: 'one'
      fill_in 'E-mail', with: 'userone@email.com'
      fill_in 'Senha', with: '12345abcdeF#'
      fill_in 'Confirme sua senha', with: '12345abcdeF#'
      fill_in 'CPF', with: cpf
      click_on 'Cadastrar-se'
    end
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'CNPJ', with: cnpj
    click_on 'Salvar Restaurante'

    expect(page).to have_content 'Não foi possível cadastrar o restaurante, siga as instruções abaixo.'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
  end
end