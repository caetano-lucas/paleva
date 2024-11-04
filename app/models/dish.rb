class Dish < ApplicationRecord
  belongs_to :restaurant
  validates :name, :description, presence: true
  has_many :dish_features
  has_many :features, through: :dish_features
  has_one_attached :image
  enum status: { active: 1, inactive: 0 }
end