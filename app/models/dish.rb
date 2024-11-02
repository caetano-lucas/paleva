class Dish < ApplicationRecord
  belongs_to :restaurant
  validates :name, :description, presence: true
  
  has_one_attached :image
  enum status: { active: 1, inactive: 0 }
end