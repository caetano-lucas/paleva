require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do 
    it 'client_name deve ser obrigatorio' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.new(client_name:'', cpf: cpf, phone: '', email: 'felipemarciel@exemple.com', restaurant: restaurant)
      
      order.valid?

      expect(order.errors.include? :client_name ).to eq true
    end

    it 'restaurante deve ser obrigatorio' do
      cpf = CPF.generate(true).split
      order = Order.new(client_name: 'Felipe Marciel', cpf: cpf, phone: '', email: 'felipemarciel@exemple.com', restaurant: nil)

      order.valid?

      expect(order.errors.include? :restaurant ).to eq true
    end
    
    it 'preenche email ou telefone' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.new(client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: nil , restaurant: restaurant)
      
      order.valid?

      expect(order.errors[:base]).to include("Você deve fornecer pelo menos um contato: telefone ou e-mail.")
    end
    it 'status 0 deve ser aguardando_confirmacao_cozinha' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(status: 0,client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      expect(order.aguardando_confirmacao_cozinha?).to eq true
    end
    it 'status 1 deve ser cancelado' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(status: 1,client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      expect(order.cancelado?).to eq true
    end
    it 'status 2 deve ser preparação' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(status: 2,client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      expect(order.preparação?).to eq true
    end
    it 'status 3 deve ser pronto' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(status: 3,client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      expect(order.pronto?).to eq true
    end
    it 'status 4 deve ser entregue' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(status: 4,client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      expect(order.entregue?).to eq true
    end
  end
  describe 'o codigo é gerado' do
    it 'com 8 digitos' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      restaurant = Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      order = Order.create(client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: 'felipemarciel@exemple.com' , restaurant: restaurant)

      result = order.alphanumeric_code

      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end
  end
end