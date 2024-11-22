require 'rails_helper'

RSpec.describe Drink, type: :model do
  describe '#valid?' do 
    it 'nome deve ser obrigatorio' do
      drink = Drink.new(name: '', description: 'A mais pedido', alcohol: true, restaurant: nil )

      drink.valid?
      
      expect(drink.errors.include? :name).to eq true
    end

    it 'descricao deve ser obrigatoria' do
      drink = Drink.new(name: 'drinktest1', description: '', alcohol: true, restaurant: nil )

      drink.valid?

      expect(drink.errors.include? :description).to eq true
    end

    it 'restaurante deve ser obrigatorio' do
      drink = Drink.new(name: 'drinktest1', description: 'A mais pedido', alcohol: true, restaurant: nil )

      drink.valid?

      expect(drink.errors.include? :restaurant).to eq true
    end
    it 'status deve ser obrigatorio' do
      cnpj1 = CNPJ.generate(true).split
      restaurant =  Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
      drink = Drink.new(name: 'drinktest1', description: 'A mais pedido', alcohol: true, restaurant: restaurant, status: 0 )
      
      drink.valid?

      expect(drink.valid?).to eq true
    end
    it 'status 1 deve ser active' do
      restaurant = Restaurant.create(trade_name: 'userOne restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      drink = Drink.new(name: 'drinktest1', description: 'A mais pedido', alcohol: true, restaurant: restaurant, status: 1 )

      expect(drink.active?).to eq true
      expect(drink.inactive?).to eq false
    end
    it 'status 0 deve ser inactive' do
      restaurant = Restaurant.create(trade_name: 'userOne restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      drink = Drink.new(name: 'drinktest1', description: 'A mais pedido', alcohol: true, restaurant: restaurant, status: 0 )

      expect(drink.active?).to eq false
      expect(drink.inactive?).to eq true
    end
  end
end
