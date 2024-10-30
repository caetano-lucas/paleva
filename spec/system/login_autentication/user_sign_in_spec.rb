require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    cpf = CPF.generate(true).split
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

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
  end

  it 'e ve seu nome no cabeçalho' do
    cpf1 = CPF.generate(true).split
    cpf2 = CPF.generate(true).split
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
    User.create!(email: 'usertwo@email.com',first_name: 'usertwo',
                 last_name: 'two', password: '12345abcdeF#', cpf: cpf2)

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
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
    expect(current_path).to eq new_user_session_path
  end
  it 'e é automaticamente redirecionado para a tela de cadastrar novo restaurante se não tiver um previamente' do
    cpf = CPF.generate(true).split
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
   
    expect(current_path).to eq new_restaurant_path
  end
end
