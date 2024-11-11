require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do 
    it 'client_name deve ser obrigatorio' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                          last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
      order = Order.new(client_name:'', cpf: cpf, phone: '', email: 'felipemarciel@exemple.com', restaurant: restaurant)
      
      order.valid?
      expect(order.errors.include? :client_name ).to eq true
    end
    it 'restaurante deve ser obrigatorio' do
      cpf = CPF.generate(true).split
      User.create!(email: 'userone@email.com',first_name: 'userone',
                          last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      order = Order.new(client_name: 'Felipe Marciel', cpf: cpf, phone: '', email: 'felipemarciel@exemple.com', restaurant: nil)
      order.valid?
      expect(order.errors.include? :restaurant ).to eq true
    end
    it 'preenche email ou telefone' do
      cpf = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                          last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com',
                                    user: user)
      order = Order.new(client_name: 'Felipe Marciel', cpf: cpf, phone: nil , email: nil , restaurant: restaurant)
      
      order.valid?
      expect(order.errors[:base]).to include("Você deve fornecer pelo menos um contato: telefone ou e-mail.")
    end
  end
end
