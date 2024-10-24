require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#')
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
    expect(page).to have_link 'Sair'
    expect(page).not_to have_link 'Entrar'
  end

  it 'e ve seu nome no cabeçalho' do
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#')
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
    User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#')
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
    expect(page).not_to have_link 'Sair'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_content 'Olá, userone'
    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end