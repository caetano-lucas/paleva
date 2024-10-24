require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    visit root_path
    click_on 'Entrar'
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: 'userone'
      fill_in 'Sobrenome', with: 'one@email.com'
      fill_in 'E-mail', with: 'userone@email.com'
      fill_in 'Senha', with: '12345abcdeF#'
      fill_in 'Confirme sua senha', with: '12345abcdeF#'
      click_on 'Cadastrar-se'
    end
    expect(page).to have_content 'Olá, userone'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso'
    expect(page).to have_link 'Sair'
    expect(page).not_to have_link 'Entrar'
    user = User.last
    expect(user.first_name).to eq 'userone'
  end
  it 'sem sucesso' do
    visit root_path
    click_on 'Entrar'
    click_on 'Cadastrar-se'
    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
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
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).not_to have_link 'Sair'
  end
end