require 'rails_helper'
require 'cpf_cnpj'

describe 'Usuário registra um restaurante, logo após se registrar,' do
  it 'com sucesso' do 
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
    fill_in 'Nome Fantasia', with: 'NomeFantasiaTeste'
    fill_in 'Razão Social', with: 'RazãoSocialTeste LTDA'
    fill_in 'Telefone', with: '11123121211'
    fill_in 'E-mail', with: 'eras@email.com'
    fill_in 'Endereço', with: 'Rua do restauranteTeste, número: 200'
    fill_in 'CNPJ', with: cnpj
    click_on 'Salvar Restaurante'

    expect(page).to have_content 'Restaurante cadastrado com sucesso'
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

    expect(page).to have_content 'ALGO DEU ERRADO, RESTAURANTE NÃO CADASTRADO'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
  end
  
end