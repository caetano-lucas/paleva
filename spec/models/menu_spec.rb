require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do 
    it 'nome deve ser obrigatorio' do
      menu = Menu.new(name: nil, restaurant: nil)

      menu.valid?
      expect(menu.errors.include? :name ).to eq true
    end
    it 'restaurante deve ser obrigatorio' do
      menu = Menu.new(name: 'Jantar', restaurant: nil)

      menu.valid?
    
      expect(menu.errors.include? :restaurant ).to eq true
    end
  end
  describe '#uniqueness' do
    it 'nome deve ser único' do
      cpf1 = CPF.generate(true).split
      cnpj1 = CNPJ.generate(true).split
      user_one = User.create!(email: 'userone@email.com',first_name: 'userone',
                              last_name: 'one', password: '12345abcdeF#', cpf: cpf1)
      restaurant_user_one = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                              cnpj: cnpj1, address: 'Restaurant street, 200', phone: '23456789102',
                                              email: 'useronerestaurant@gmail.com')
      user_one.update!(restaurant_id: restaurant_user_one, position: :owner)
      Menu.create!(name: 'Jantar', restaurant: restaurant_user_one)
      menu = Menu.new(name: 'Jantar', restaurant: restaurant_user_one)

      menu.valid?
      expect(menu.errors.include? :name ).to eq true
    end
  end
end
