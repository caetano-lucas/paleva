require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário registra um restaurante' do
  it 'com sucesso' do 
    cpf = CPF.generate(true)
    cnpj = CNPJ.generate(true)
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
      click_on 'Cadastrar Restaurante'
    end
    fill_in 'Nome Fantasia', with: 'NomeFantasiaTeste'
    fill_in 'Razão Social', with: 'RazãoSocialTeste LTDA'
    fill_in 'Telefone', with: '11123121211'
    fill_in 'E-mail', with: 'NomeFantasiaTeste@gmail.com'
    fill_in 'Endereço', with: 'Rua do restauranteTeste, número: 200'
    fill_in 'CNPJ', with: cnpj
    click_on 'Salvar Restaurante'

    expect(page).to have_content 'Restaurante cadastrado com sucesso'
  end

end