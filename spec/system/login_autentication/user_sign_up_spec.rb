require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário se registra' do
  it 'com sucesso' do
    cpf = CPF.generate(true).strip

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
    end
    click_on 'Cadastrar-se'

    expect(page).to have_content 'Olá, userone'
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
    user = User.last
    expect(user.first_name).to eq 'userone'
    expect(CPF.valid?(cpf)).to eq true
  end

  it 'e é automaticamente redirecionado para a tela de cadastrar novo restaurante' do
    cpf = CPF.generate(true).strip

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
    end
    click_on 'Cadastrar-se'
   
    expect(current_path).to eq new_restaurant_path
  end

  it 'sem sucesso' do
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      fill_in 'CPF', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirme sua senha', with: ''
      click_on 'Cadastrar-se'
    end

    expect(page).to have_content 'Entrar'
    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).not_to have_link 'Sair'
  end
  it 'com cpf único' do
    cpf = CPF.generate(true).strip
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '11111abcdeF#', cpf: cpf)

    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'usertwo'
      fill_in 'Sobrenome', with: 'two'
      fill_in 'E-mail', with: 'usertwo@email.com'
      fill_in 'Senha', with: '22222abcdeF#'
      fill_in 'Confirme sua senha', with: '22222abcdeF#'
      fill_in 'CPF', with: cpf
      click_on 'Cadastrar-se'
    end

    expect(page).not_to have_content 'Olá, usertwo'
    expect(page).to have_content 'CPF já está em uso'
    expect(page).to have_button 'Cadastrar-se'
  end
  it 'sem sucesso com cpf inválido' do
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'usertwo'
      fill_in 'Sobrenome', with: 'two'
      fill_in 'E-mail', with: 'usertwo@email.com'
      fill_in 'Senha', with: '22222abcdeF#'
      fill_in 'Confirme sua senha', with: '22222abcdeF#'
      fill_in 'CPF', with: '111.111.111-11'
      click_on 'Cadastrar-se'
    end

    expect(page).not_to have_content 'Olá, usertwo'
    expect(page).to have_content 'CPF não é um CPF válido'
    expect(page).to have_button 'Cadastrar-se'
  end
  it 'sem sucesso com email inválido' do
    cpf = CPF.generate(true).strip

    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'usertwo'
      fill_in 'Sobrenome', with: 'two'
      fill_in 'E-mail', with: 'usertwoemail.com'
      fill_in 'Senha', with: '22222abcdeF#'
      fill_in 'Confirme sua senha', with: '22222abcdeF#'
      fill_in 'CPF', with: cpf
      click_on 'Cadastrar-se'
    end
    
    expect(page).not_to have_content 'Olá, usertwo'
    expect(page).to have_content 'E-mail não é válido'
    expect(page).to have_button 'Cadastrar-se'
  end

  it 'se não tiver pre cadastro é employee até que registre um restaurante' do
    cpf = CPF.generate(true).strip

    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'usertwo'
      fill_in 'Sobrenome', with: 'two'
      fill_in 'E-mail', with: 'usertwo@email.com'
      fill_in 'Senha', with: '22222abcdeF#'
      fill_in 'Confirme sua senha', with: '22222abcdeF#'
      fill_in 'CPF', with: cpf
      click_on 'Cadastrar-se'
    end
    
    expect(User.last.owner?).to eq false
  end

  it 'se tiver pre cadastro é funcionário' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    cnpj1 = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                            last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                            cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                            email: 'useronerestaurant@gmail.com')
                                            
    Employee.create!(restaurant: restaurant, user: user, email:'usertwo@email.com', cpf: cpf2 )
    
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'usertwo'
      fill_in 'Sobrenome', with: 'two'
      fill_in 'E-mail', with: 'usertwo@email.com'
      fill_in 'Senha', with: '22222abcdeF#'
      fill_in 'Confirme sua senha', with: '22222abcdeF#'
      fill_in 'CPF', with: "#{cpf2}"
      click_on 'Cadastrar-se'
    end
    
    expect(User.last.owner?).to eq false
    expect(User.last.restaurant_id).to eq restaurant.id
  end
end
