require 'rails_helper'

describe 'usuario vê porções' do  
  it 'dos pratos com sucesso' do
    cpf = CPF.generate(true).split
    cnpj = CNPJ.generate(true).split
    user = User.create!(email: 'userone@email.com',first_name: 'userone',
    last_name: 'one', password: '12345abcdeF#', cpf: cpf)
    restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
    dish1 = Dish.create!(name: 'Macarrão', description: 'Alho e óleo', calories: 700, restaurant: restaurant )
    feature1 = Feature.create!(name: 'Glúten', restaurant: restaurant)
    DishFeature.create!(dish: dish1, feature: feature1)
    #DishPortion.create!(dish: dish1, portion1: portion1)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Pratos Cadastrados'
    end
    click_on 'Detalhes Macarrão'
    click_on 'Cadastrar porção'
    fill_in 'Descrição', with: 'Meia porção - 3 pessoas'
    fill_in 'Preço (Parte Inteira - R$)', with: '45'
    fill_in 'Centavos', with: '99'
    click_on 'Salvar'
    expect(page).to have_content 'Porções Cadastradas Para este prato:'
    expect(page).to have_content 'Descrição da Porção'
    expect(page).to have_content 'Meia porção - 3 pessoas'
    expect(page).to have_content '45,99'
  end
end
