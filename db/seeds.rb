# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user1 = User.create!(first_name: "José", last_name: "Silva", email: "jose.silva@example.com", cpf: "02149587017", password: "password123123")
user2 = User.create!(first_name: "Maria", last_name: "Fernandes", email: "maria.fernandes@example.com", cpf: "84884225040", password: "password123123")

restaurant1 = Restaurant.create!(trade_name: "Bistro do José", legal_name: "Bistro José Ltda", cnpj: "93860545000159", address: "Rua 1, 100", phone: "11999999999", email: "contato@bistrojose.com", alphanumeric_code: "BJ0012")
restaurant2 = Restaurant.create!(trade_name: "Cantina da Maria", legal_name: "Cantina Maria Ltda", cnpj: "66697438000189", address: "Rua 2, 200", phone: "11988888888", email: "contato@cantinamaria.com", alphanumeric_code: "CCM002")

user1.update(restaurant_id: restaurant1.id)
user2.update(restaurant_id: restaurant2.id)

Menu.create!(name: "Café da Manhã", restaurant_id: 1)
Menu.create!(name: "Jantar Romântico", restaurant_id: 1)
Menu.create!(name: "Almoço Executivo", restaurant_id: 1)

Menu.create!(name: "Café da Manhã", restaurant_id: 2)
Menu.create!(name: "Almoço Executivo", restaurant_id: 2)
Menu.create!(name: "Menu Vegano", restaurant_id: 2)

Dish.create!(name: "Pão de Queijo", description: "Pão de queijo tradicional mineiro", calories: "150", restaurant_id: 1)
Dish.create!(name: "Salada Vegetariana", description: "Salada de vegetais frescos", calories: "100", restaurant_id: 1)
Dish.create!(name: "Feijão tropeiro", description: "Feijoada com acompanhamentos", calories: "650", restaurant_id: 1)
Dish.create!(name: "Sushi", description: "Combinado de sushi", calories: "300", restaurant_id: 1)

Dish.create!(name: "Feijoada", description: "Feijoada com acompanhamentos", calories: "600", restaurant_id: 2)
Dish.create!(name: "Pão na chapa", description: "Pão de queijo tradicional mineiro", calories: "250", restaurant_id: 2)
Dish.create!(name: "Sushi", description: "Combinado de sashimi", calories: "400", restaurant_id: 2)
Dish.create!(name: "Salada Vegana", description: "Salada com grãos", calories: "200", restaurant_id: 2)

Drink.create!(name: "Suco de Laranja", description: "Suco de laranja", alcohol: false, restaurant_id: 1)
Drink.create!(name: "Suco de Uva", description: "Suco de uva", alcohol: false, restaurant_id: 1)
Drink.create!(name: "Caipirinha de vinho", description: "Caipirinha de vinho limão", alcohol: true, restaurant_id: 1)
Drink.create!(name: "Suco de Laranja", description: "Suco de laranja natural", alcohol: false, restaurant_id: 2)
Drink.create!(name: "Caipirinha de vinho", description: "Caipirinha de vinho limão", alcohol: true, restaurant_id: 2)
Drink.create!(name: "Caipirinha de cachaça", description: "Caipirinha de limão com cachaça", alcohol: true, restaurant_id: 2)
Drink.create!(name: "Vinho Tinto", description: "Vinho tinto seco", alcohol: true, restaurant_id: 2)
Drink.create!(name: "Chá Gelado", description: "Chá verde com limão e hortelã", alcohol: false, restaurant_id: 2)

Feature.create!(name: "Sem glúten", restaurant_id: 1)
Feature.create!(name: "Sem lactose", restaurant_id: 1)
Feature.create!(name: "Orgânico", restaurant_id: 1)
Feature.create!(name: "Apimentado", restaurant_id: 1)

Feature.create!(name: "Sem glúten", restaurant_id: 2)
Feature.create!(name: "Sem lactose", restaurant_id: 2)
Feature.create!(name: "Orgânico", restaurant_id: 2)
Feature.create!(name: "Vegano", restaurant_id: 2)

ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Pão de Queijo", restaurant_id: 1), feature: Feature.find_by(name: "Sem glúten", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Pão de Queijo", restaurant_id: 1), feature: Feature.find_by(name: "Orgânico", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Salada Vegetariana", restaurant_id: 1), feature: Feature.find_by(name: "Sem lactose", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Salada Vegetariana", restaurant_id: 1), feature: Feature.find_by(name: "Orgânico", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Feijão tropeiro", restaurant_id: 1), feature: Feature.find_by(name: "Apimentado", restaurant_id: 1))

ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Suco de Laranja", restaurant_id: 1), feature: Feature.find_by(name: "Orgânico", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Suco de Uva", restaurant_id: 1), feature: Feature.find_by(name: "Sem glúten", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Suco de Uva", restaurant_id: 1), feature: Feature.find_by(name: "Orgânico", restaurant_id: 1))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Caipirinha de vinho", restaurant_id: 1), feature: Feature.find_by(name: "Apimentado", restaurant_id: 1))

ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Feijoada", restaurant_id: 2), feature: Feature.find_by(name: "Sem glúten", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Feijoada", restaurant_id: 2), feature: Feature.find_by(name: "Sem lactose", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Salada Vegana", restaurant_id: 2), feature: Feature.find_by(name: "Vegano", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Dish.find_by(name: "Salada Vegana", restaurant_id: 2), feature: Feature.find_by(name: "Orgânico", restaurant_id: 2))

ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Suco de Laranja", restaurant_id: 2), feature: Feature.find_by(name: "Orgânico", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Caipirinha de vinho", restaurant_id: 2), feature: Feature.find_by(name: "Sem lactose", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Caipirinha de cachaça", restaurant_id: 2), feature: Feature.find_by(name: "Sem glúten", restaurant_id: 2))
ItemFeature.find_or_create_by!(featurable: Drink.find_by(name: "Chá Gelado", restaurant_id: 2), feature: Feature.find_by(name: "Orgânico", restaurant_id: 2))

Portion.find_or_create_by!(description: "Porção pequena", price_whole: 20, price_cents: 0, portionable: Dish.find_by(name: "Pão de Queijo"))
Portion.find_or_create_by!(description: "Porção média", price_whole: 30, price_cents: 0, portionable: Dish.find_by(name: "Pão de Queijo"))
Portion.find_or_create_by!(description: "Copo", price_whole: 10, price_cents: 50, portionable: Drink.find_by(name: "Suco de Laranja"))
Portion.find_or_create_by!(description: "Jarra", price_whole: 25, price_cents: 50, portionable: Drink.find_by(name: "Suco de Laranja"))
Portion.find_or_create_by!(description: "Porção individual", price_whole: 25, price_cents: 50, portionable: Dish.find_by(name: "Salada Vegetariana"))
Portion.find_or_create_by!(description: "Taça", price_whole: 15, price_cents: 55, portionable: Drink.find_by(name: "Caipirinha de vinho"))
Portion.find_or_create_by!(description: "Porção grande", price_whole: 40, price_cents: 0, portionable: Dish.find_by(name: "Feijão tropeiro"))
Portion.find_or_create_by!(description: "Garrafa", price_whole: 125, price_cents: 50, portionable: Drink.find_by(name: "Suco de Uva"))
Portion.find_or_create_by!(description: "Porção média", price_whole: 30, price_cents: 0, portionable: Dish.find_by(name: "Pão na chapa"))
Portion.find_or_create_by!(description: "Jarra", price_whole: 25, price_cents: 50, portionable: Drink.find_by(name: "Suco de Laranja"))
Portion.find_or_create_by!(description: "Porção grande", price_whole: 40, price_cents: 0, portionable: Dish.find_by(name: "Feijoada"))
Portion.find_or_create_by!(description: "Taça", price_whole: 15, price_cents: 55, portionable: Drink.find_by(name: "Caipirinha de cachaça"))
Portion.find_or_create_by!(description: "Porção individual", price_whole: 25, price_cents: 50, portionable: Dish.find_by(name: "Salada Vegana"))
Portion.find_or_create_by!(description: "Garrafa", price_whole: 125, price_cents: 50, portionable: Drink.find_by(name: "Chá Gelado"))

MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Pão de Queijo"), menu: Menu.find_by(name: "Café da Manhã"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Suco de Laranja"), menu: Menu.find_by(name: "Café da Manhã"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Salada Vegetariana"), menu: Menu.find_by(name: "Jantar Romântico"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Caipirinha de vinho"), menu: Menu.find_by(name: "Jantar Romântico"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Feijão tropeiro"), menu: Menu.find_by(name: "Almoço Executivo"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Suco de Uva"), menu: Menu.find_by(name: "Almoço Executivo"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Pão na chapa"), menu: Menu.find_by(name: "Café da Manhã"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Suco de Laranja"), menu: Menu.find_by(name: "Café da Manhã"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Feijoada"), menu: Menu.find_by(name: "Almoço Executivo"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Caipirinha de cachaça"), menu: Menu.find_by(name: "Almoço Executivo"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Salada Vegana"), menu: Menu.find_by(name: "Menu Vegano"))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Chá Gelado"), menu: Menu.find_by(name: "Menu Vegano"))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Pão na chapa"), menu: Menu.find_by(name: "Café da Manhã", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Feijoada"), menu: Menu.find_by(name: "Almoço Executivo", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Dish.find_by(name: "Salada Vegana"), menu: Menu.find_by(name: "Menu Vegano", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Suco de Laranja", restaurant_id: 2), menu: Menu.find_by(name: "Café da Manhã", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Caipirinha de vinho", restaurant_id: 2), menu: Menu.find_by(name: "Almoço Executivo", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Caipirinha de cachaça", restaurant_id: 2), menu: Menu.find_by(name: "Almoço Executivo", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Vinho Tinto", restaurant_id: 2), menu: Menu.find_by(name: "Almoço Executivo", restaurant_id: 2))
MenuItem.find_or_create_by!(menu_itemable: Drink.find_by(name: "Chá Gelado", restaurant_id: 2), menu: Menu.find_by(name: "Menu Vegano", restaurant_id: 2))

OperatingHour.create!(day: "segunda-feira", open_time: "08:00", close_time: "22:00", closed: false, restaurant_id: Restaurant.find(1).id)
OperatingHour.create!(day: "terça-feira", open_time: "08:00", close_time: "22:00", closed: false, restaurant_id: Restaurant.find(1).id)
OperatingHour.create!(day: "quarta-feira", open_time: "08:00", close_time: "22:00", closed: false, restaurant_id: Restaurant.find(2).id)
OperatingHour.create!(day: "domingo", open_time: "10:00", close_time: "18:00", closed: false, restaurant_id: Restaurant.find(2).id)