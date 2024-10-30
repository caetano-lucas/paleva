require 'rails_helper'
require 'cpf_cnpj'

describe 'usuario registra novas bebidas para seu restaurante' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Bebidas Cadastradas'
    expect(current_path).not_to have_link 'Cadastrar nova Bebida'
    
  end

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
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Cadastrar nova Bebida'   
    fill_in 'Nome da Bebida', with: 'NomeBebidaTeste'
    fill_in 'Descrição', with: 'DescriçãoBebidaTeste'
    check 'Álcool'
    click_on 'Salvar Bebida'
  
    expect(page).to have_content 'NomeBebidaTeste'
    expect(page).to have_content 'DescriçãoBebidaTeste'
    expect(page).to have_content 'Possui Álcool'
    expect(page).to have_content 'Lista de Bebidas'
  end

  it 'sem sucesso' do
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
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Cadastrar nova Bebida'   
    fill_in 'Nome da Bebida', with: ''
    fill_in 'Descrição', with: ''
    check 'Álcool'
    click_on 'Salvar Bebida'
  
    expect(page).to have_content 'ALGO DEU ERRADO, BEBIDA NÃO CADASTRADA'
    expect(page).to have_content 'Nome da Bebida não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end
  it 'e não clica em salvar' do 
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
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Cadastrar nova Bebida'
    fill_in 'Nome da Bebida', with: 'NomeBebidaTeste'
    fill_in 'Descrição', with: 'DescriçãoBebidaTeste'
    check 'Álcool'
    click_on 'PaLevá'
    within('nav') do
      click_on 'Bebidas Cadastradas'
    end
    click_on 'Cadastrar nova Bebida'
  
    expect(page).not_to have_content 'NomeBebidaTeste'
    expect(page).not_to have_content 'DescriçãoBebidaTeste'
  end
end