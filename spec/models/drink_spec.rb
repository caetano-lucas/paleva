require 'rails_helper'

RSpec.describe Drink, type: :model do
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
  end
end
