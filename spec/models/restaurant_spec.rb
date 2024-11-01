require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'nome fantasia deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: '', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :trade_name).to be true
      end

      it 'razão social de ser obrigatória' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: '',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :legal_name).to be true
      end

      it 'CNPJ deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :cnpj).to be true
      end

      it 'endereço deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: '', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :address).to be true
      end

      it 'telefone deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :phone).to be true
      end
      
      it 'email deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: '', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :email).to be true
      end
    
      it 'usuário deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: nil)
        restaurant.valid?
        expect(restaurant.errors.include? :user).to be true
      end
    end

    context 'uniqueness' do
      # validates  :cnpj, :phone, :email, :alphanumeric_code, uniqueness: true
      it 'falso quando a razão social não é única' do
        cpf1 = CPF.generate(true).split
        cnpj1 = CNPJ.generate(true).split
        cpf2= CPF.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        user_one = User.create(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
        restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com', user: user_one)

        user_two = User.create(email: 'userone@email.com',first_name: 'usertwo',
                  last_name: 'two', password: '22222abcdeF#', cpf: cpf2)
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'usertworestaurant@gmail.com', user: user_two)
      
        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o CNPJ não é único' do
        cpf1 = CPF.generate(true).split
        cnpj1 = CNPJ.generate(true).split
        cpf2= CPF.generate(true).split
        user_one = User.create(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
        restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com', user: user_one)

        user_two = User.create(email: 'userone@email.com',first_name: 'usertwo',
                  last_name: 'two', password: '22222abcdeF#', cpf: cpf2)
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'usertworestaurant@gmail.com', user: user_two)
      
        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o telefone não é único' do
        cpf1 = CPF.generate(true).split
        cnpj1 = CNPJ.generate(true).split
        cpf2= CPF.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        user_one = User.create(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
        restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com', user: user_one)

        user_two = User.create(email: 'userone@email.com',first_name: 'usertwo',
                  last_name: 'two', password: '22222abcdeF#', cpf: cpf2)
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '1111111111',
                                      email: 'usertworestaurant@gmail.com', user: user_two)
      
        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o email não é único' do
        cpf1 = CPF.generate(true).split
        cnpj1 = CNPJ.generate(true).split
        cpf2= CPF.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        user_one = User.create(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
        restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com', user: user_one)

        user_two = User.create(email: 'userone@email.com',first_name: 'usertwo',
                  last_name: 'two', password: '22222abcdeF#', cpf: cpf2)
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'useronerestaurant@gmail.com', user: user_two)
      
        result = restaurant_two.valid?

        expect(result).to eq false
      end
    end
  end

  describe 'o codigo é gerado' do
    it 'com 6 digitos' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                 last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com', user: user)
      result = restaurant.alphanumeric_code
      expect(result).not_to be_empty
      expect(result.length).to eq 6
    end
  end
end
