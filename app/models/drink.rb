class Drink < ApplicationRecord
  belongs_to :restaurant
  
  validates :name, :description, :restaurant_id, presence: true
 


end
