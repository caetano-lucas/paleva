class Drink < ApplicationRecord
  belongs_to :restaurant
  
  validates :name, :description, :alcohol, :restaurant_id, presence: true
  validates :name, :description, :alcohol, :restaurant_id, uniqueness: true


end
