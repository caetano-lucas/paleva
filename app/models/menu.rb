class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items

  has_many :dishes, through: :menu_items, source: :menu_itemable, source_type: 'Dish'
  has_many :drinks, through: :menu_items, source: :menu_itemable, source_type: 'Drink'

  validates :name, uniqueness: { scope: :restaurant_id, message: "já foi cadastrado para este restaurante" }
  validates :name, :restaurant_id, presence: true
end

