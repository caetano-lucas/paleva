class Feature < ApplicationRecord
  belongs_to :restaurant
  has_many :dish_features
  has_many :dishes, through: :dish_features
end
