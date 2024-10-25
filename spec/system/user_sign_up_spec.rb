require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    cpf = CPF.generate(true)
    visit root_path
    click_on 'Entrar'
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
    expect(page).to have_content 'Olá, userone'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso'
    expect(page).to have_link 'Sair'
    expect(page).not_to have_link 'Entrar'
    user = User.last
    expect(user.first_name).to eq 'userone'
    expect(CPF.valid?(cpf)).to eq true
  end
  it 'sem sucesso' do
    visit root_path
    click_on 'Entrar'
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
    cpf = CPF.generate(true)
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '11111abcdeF#', cpf: cpf)
    cpf_2 = CPF.generate(true)
    visit root_path
    click_on 'Entrar'
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
    click_on 'Entrar'
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
end