require 'rails_helper'

RSpec.describe Dish, type: :model do
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
  end
end
