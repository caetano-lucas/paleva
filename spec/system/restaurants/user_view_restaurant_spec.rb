require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario ve o seu restaurante' do
  it 'se estiver autenticado' do
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
    within('nav') do
      click_on 'Restaurante'
    end
    expect(current_path).to eq root_path
  end
end