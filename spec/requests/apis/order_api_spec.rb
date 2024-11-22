require 'rails_helper'

describe 'Orders API' do
  context 'GET api/v1/restaurant/1/orders/1' do
    it 'success' do 
      cpf = CPF.generate(true).split
      cpf2 = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                      email: 'useronerestaurant@gmail.com')
      user.update!(restaurant_id: restaurant.id, position: :owner)
      dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
      portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish.id)

      order = Order.create!(client_name: 'Felipe Marciel', cpf: "#{cpf2}", phone: nil, email: 'felipemarciel@exemple.com',
                    restaurant: restaurant, status: 0)
      
      _order_item = OrderItem.create!(portion: portion1, order: order, quantity: 2, price: portion1.price_whole.to_i, cents: portion1.price_cents.to_i, note: 'sem cebola')
      order.update!(total_price: 30.15)
      
      get "/api/v1/restaurants/#{restaurant.alphanumeric_code}/orders/#{order.alphanumeric_code}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response['order']["client_name"]).to eq('Felipe Marciel')
      expect(json_response['order']["client_name"]).to eq('Felipe Marciel')
      expect(json_response.keys).not_to include('criated_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'fail if restaurant and order not found' do

      get '/api/v1/restaurants/123123/orders/123121'

      expect(response.status).to eq 404
    end
  end

  context 'GET api/v1/restaurant/1/orders' do
    it 'success' do 
      cpf = CPF.generate(true).split
      cpf2 = CPF.generate(true).split
      cpf3 = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                      email: 'useronerestaurant@gmail.com')
      user.update!(restaurant_id: restaurant.id, position: :owner)
      dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
      portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish.id)

      order = Order.create!(client_name: 'Felipe Marciel', cpf: "#{cpf2}", phone: nil, email: 'felipemarciel@exemple.com',
                    restaurant: restaurant, status: 0)
      order2 = Order.create!(client_name: 'Joao gustavo', cpf: "#{cpf3}", phone: nil, email: 'Joao@exemple.com',
                    restaurant: restaurant, status: 0)
      OrderItem.create!(portion: portion1, order: order, quantity: 2, price: portion1.price_whole.to_i, cents: portion1.price_cents.to_i, note: 'sem cebola')
      OrderItem.create!(portion: portion1, order: order2, quantity: 2, price: portion1.price_whole.to_i, cents: portion1.price_cents.to_i, note: 'com cebola')
      order.update!(total_price: 30.15)
      order2.update!(total_price: 30.15)
      
      get "/api/v1/restaurants/#{restaurant.alphanumeric_code}/orders/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response['orders'][0]["client_name"]).to eq ('Felipe Marciel')
      expect(json_response['orders'][1]["client_name"]).to eq('Joao gustavo')
      expect(json_response['orders'][0]["status"]).not_to eq ''
      expect(json_response['orders'][1]["status"]).not_to eq ''
      expect(json_response.keys).not_to include('criated_at')
      expect(json_response.keys).not_to include('updated_at')
    end
    it 'and filter results by status' do 
      cpf = CPF.generate(true).split
      cpf2 = CPF.generate(true).split
      cnpj = CNPJ.generate(true).split
      user = User.create!(email: 'userone@email.com',first_name: 'userone',
                  last_name: 'one', password: '12345abcdeF#', cpf: cpf)
      restaurant = Restaurant.create!(trade_name: 'userone-restaurant', legal_name: 'userRestaurant LTDA',
                                      cnpj: cnpj, address: 'Restaurant street, 200', phone: '23456789102',
                                      email: 'useronerestaurant@gmail.com')
      user.update!(restaurant_id: restaurant.id, position: :owner)
      dish = Dish.create!(name: 'Macarronada', description: 'Carne - provolone', calories: 1800, restaurant: restaurant )
      portion1 = Portion.create!(description: 'Meia porção - 3 pessoas', price_whole: 45, price_cents: 99, portionable_type: 'Dish', portionable_id: dish.id)

      order = Order.create!(client_name: 'Felipe Marciel', cpf: "#{cpf2}", phone: nil, email: 'felipemarciel@exemple.com',
                    restaurant: restaurant, status: 0)
      
      _order_item = OrderItem.create!(portion: portion1, order: order, quantity: 2, price: portion1.price_whole.to_i, cents: portion1.price_cents.to_i, note: 'sem cebola')
      order.update!(total_price: 30.15)
     
      get "/api/v1/restaurants/#{restaurant.alphanumeric_code}/orders?status=#{order.status.to_i}"
      
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response['orders'][0]["client_name"]).to eq ('Felipe Marciel')
      expect(json_response.keys).not_to include('criated_at')
      expect(json_response.keys).not_to include('updated_at')
    end
    it 'fail if restaurant not found' do

      get '/api/v1/restaurants/123123/orders'

      expect(response.status).to eq 404
    end

  end

  
end