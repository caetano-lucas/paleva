require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario registra novos pratos para seu restaurante' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Pratos Cadastrados'    
  end

  it 'com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)
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
    
    expect(page).to have_content 'NomePratoTeste'
    expect(page).to have_content 'DescriçãoPratoTeste'
    expect(page).to have_content 'Prato cadastrado com sucesso'
    expect(page).to have_content 'Ativo'
  end
  
  it 'sem sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                 cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                 email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)

    login_as(user)
    visit root_path
    within('nav') do
      click_on  'Pratos Cadastrados'
    end
    click_on 'Cadastrar novo prato'
    fill_in 'Nome do Prato', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: ''
    click_on 'Salvar Prato'
  
    expect(page).to have_content 'ALGO DEU ERRADO, PRATO NÃO CADASTRADO'
    expect(page).to have_content 'Nome do Prato não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end
  
  it 'e não clica em salvar' do 
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                 cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                 email: 'useronerestaurant@gmail.com')
    user.update!(restaurant_id: restaurant.id)

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
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Cadastrar novo prato'
  
    expect(page).not_to have_content 'NomePratoTeste'
    expect(page).not_to have_content 'DescriçãoPratoTeste'
  end
end