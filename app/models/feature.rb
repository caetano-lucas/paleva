class Feature < ApplicationRecord
  belongs_to :restaurant
  has_many :item_features
  has_many :dishes, through: :item_features, source: :featurable, source_type: 'Dish'
  has_many :drinks, through: :item_features, source: :featurable, source_type: 'Drink'
end
