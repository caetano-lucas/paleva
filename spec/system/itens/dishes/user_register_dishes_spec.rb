require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario registra novos pratos para seu restaurante' do
  it 'com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Cadastrar novo prato'
    fill_in 'Nome do Prato', with: 'NomePratoTeste'
    fill_in 'Descrição', with: 'DescriçãoPratoTeste'
    fill_in 'Calorias', with: 'Quantidade de calorias do PratoTeste1'
    click_on 'Salvar Prato'
    
    expect(current_path).to eq dishes_path
    expect(page).to have_content 'NomePratoTeste'
    expect(page).to have_content 'DescriçãoPratoTeste'
    expect(page).to have_content 'Calorias'
    expect(page).to have_content 'Lista de Pratos'
  end
end