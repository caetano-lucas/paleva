require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid?' do 
    it 'nome deve ser obrigatorio' do
      dish = Dish.new(name: '', description: 'O mais pedido', calories: 1000, restaurant: nil )

      dish.valid?
      expect(dish.errors.include? :name ).to eq true
    end
    it 'descricao deve ser obrigatoria' do
      dish = Dish.new(name: 'PratoPrincipal', description: '', calories: 1000, restaurant: nil )

      dish.valid?
      
      expect(dish.errors.include? :description ).to eq true
    end
    it 'restaurante deve ser obrigatorio' do
      dish = Dish.new(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: nil )

      dish.valid?
      expect(dish.errors.include? :restaurant).to eq true
    end
    it 'status deve ser obrigatorio' do
      cnpj1 = CNPJ.generate(true).split
      restaurant =  Restaurant.create(trade_name: 'userone-restaurant', legal_name: 'userRestaurant-one LTDA',
                                      cnpj: cnpj1, address: 'Restaurant street, 111', phone: '1111111111',
                                      email: 'useronerestaurant@gmail.com')
      dish = Dish.new(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant )
      dish.valid?

      expect(dish.valid?).to eq true
    end
    it 'é criado com status 1 deve ser active' do
      restaurant = Restaurant.create(trade_name: 'userOne restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      dish = Dish.new(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant )

      expect(dish.active?).to eq true
      expect(dish.inactive?).to eq false
    end
    it 'status 0 deve ser inactive' do
      restaurant = Restaurant.create(trade_name: 'userOne restaurant', legal_name: 'userRestaurant LTDA',
                                    cnpj: nil, address: 'Restaurant street, 200', phone: '23456789102',
                                    email: 'useronerestaurant@gmail.com')
      dish = Dish.new(name: 'PratoPrincipal', description: 'O mais pedido', calories: 1000, restaurant: restaurant, status: 0 )

      expect(dish.active?).to eq false
      expect(dish.inactive?).to eq true
    end
  end
end
