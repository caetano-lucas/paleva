require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'nome fantasia deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: '', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
        restaurant.valid?
        expect(restaurant.errors.include? :trade_name).to be true
      end

      it 'razão social de ser obrigatória' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: '',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
        restaurant.valid?
        expect(restaurant.errors.include? :legal_name).to be true
      end

      it 'CNPJ deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
        restaurant.valid?
        expect(restaurant.errors.include? :cnpj).to be true
      end

      it 'endereço deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: '', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
        restaurant.valid?
        expect(restaurant.errors.include? :address).to be true
      end

      it 'telefone deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '',
                                    email: 'useronerestaurant@gmail.com')
        restaurant.valid?
        expect(restaurant.errors.include? :phone).to be true
      end

      it 'email deve ser obrigatório' do
        restaurant = Restaurant.new(trade_name: 'userone@email.com', legal_name: 'userRestaurant',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: '')
        restaurant.valid?
        expect(restaurant.errors.include? :email).to be true
      end

    end

    context 'uniqueness' do
      it 'falso quando a razão social não é única' do
        cnpj1 = CNPJ.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'usertworestaurant@gmail.com')

        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o CNPJ não é único' do
        cnpj1 = CNPJ.generate(true).split
        _restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'usertworestaurant@gmail.com')

        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o telefone não é único' do
        cnpj1 = CNPJ.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')

        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '1111111111',
                                      email: 'usertworestaurant@gmail.com')

        result = restaurant_two.valid?

        expect(result).to eq false
      end

      it 'falso quando o email não é único' do
        cnpj1 = CNPJ.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        _restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'useronerestaurant@gmail.com')

        result = restaurant_two.valid?

        expect(result).to eq false
      end
      it 'falso quando o código alfanumérico não é único' do
        cnpj1 = CNPJ.generate(true).split
        cnpj2 = CNPJ.generate(true).split
        restaurant_one = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
        restaurant_two = Restaurant.new(trade_name: 'usertwo-restaurant', legal_name: 'userRestaurant-two LTDA',
                                      cnpj: cnpj2, address: 'Restaurant street, 222', phone: '2222222222',
                                      email: 'usertworestaurant@gmail.com', alphanumeric_code: restaurant_one.alphanumeric_code)

        result = restaurant_two.valid?
        expect(result).to eq false
      end
    end

    context 'requisitos' do
      it 'telefone tem 11 digitos' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                      email: 'useronerestaurant@gmail.com')
        result = restaurant.valid?
        expect(result).to eq true
      end
      it 'telefone tem de 10 digitos' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '2345678910',
                                      email: 'useronerestaurant@gmail.com')
        result = restaurant.valid?
        expect(result).to eq true
      end
      it 'telefone tem de 12 digitos' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '234567891021',
                                      email: 'useronerestaurant@gmail.com')
        result = restaurant.valid?
        expect(result).to eq false
      end
      it 'telefone tem de 9 digitos' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '123456789',
                                      email: 'useronerestaurant@gmail.com')
        result = restaurant.valid?
        expect(result).to eq false
      end
      it 'email tem o @' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '1234567891',
                                      email: 'useronerestaurantgmail.com')
        result = restaurant.valid?
        expect(result).to eq false
      end
      it 'email tem no minimo 4 caracteres' do
        cnpj = CNPJ.generate(true).split
        restaurant = Restaurant.new(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '1234567891',
                                      email: 'a@e.')
        result = restaurant.valid?
        expect(result).to eq false
      end
    end
  end

  describe 'o codigo é gerado' do
    it 'com 6 digitos' do
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      result = restaurant.alphanumeric_code
      expect(result).not_to be_empty
      expect(result.length).to eq 6
    end
  end

  
end
