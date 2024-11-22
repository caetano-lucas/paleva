require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '#valid?' do 
    it 'email deve ser obrigatorio' do
      cpf = CPF.generate(true).split
      employee = Employee.new(email: nil, cpf: cpf)

      employee.valid?
      expect(employee.errors.include? :email ).to eq true
    end
    it 'cpf deve ser obrigatorio' do
      employee = Employee.new(email: 'exemple@gmail.com', cpf: nil)

      employee.valid?
      expect(employee.errors.include? :cpf ).to eq true
    end
    it 'restaurante deve ser obrigatorio' do
      employee = Employee.new(email: 'exemple@gmail.com', cpf: nil)

      employee.valid?
      expect(employee.errors.include? :restaurant ).to eq true
    end  
    it 'usuário.owner deve ser obrigatorio' do
      employee = Employee.new(email: 'exemple@gmail.com', cpf: nil)

      employee.valid?
      expect(employee.errors.include? :user ).to eq true
    end      
  end
  describe '#uniqueness' do
    it 'cpf deve ser único' do
      cpf = CPF.generate(true).split
      cpf2 = CPF.generate(true).split
    
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf2)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                      email: 'useronerestaurant@gmail.com')
      user.update!(restaurant_id: restaurant.id, position: :owner)

      Employee.create!(email: 'exemple@gmail.com', cpf: cpf, restaurant: restaurant, user: user)
      employee = Employee.new(email: 'usertwo@gmail.com', cpf: cpf)

      employee.valid?
      expect(employee.errors.include? :cpf ).to eq true
    end
  end
end
