require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    cpf = CPF.generate(true)
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('form') do
      fill_in 'E-mail', with: 'userone@email.com'
      fill_in 'Senha', with: '12345abcdeF#'
      click_on 'Entrar'
    end
    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
  end

  it 'e ve seu nome no cabeçalho' do
    cpf = CPF.generate(true)
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('form') do
      fill_in 'E-mail', with: 'userone@email.com'
      fill_in 'Senha', with: '12345abcdeF#'
      click_on 'Entrar'
    end
    expect(page).to have_content 'Olá, userone'
  end

  it 'e faz logout com sucesso' do
    cpf = CPF.generate(true)
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf )
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('form') do
      fill_in 'E-mail', with: 'userone@email.com'
      fill_in 'Senha', with: '12345abcdeF#'
      click_on 'Entrar'
    end
    within('nav') do
      click_on 'Sair'
    end

    expect(page).not_to have_button 'Sair'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_content 'Olá, userone'
    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end