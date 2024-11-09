class Dish < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image
  has_many :portions, as: :portionable, dependent: :destroy

  has_many :item_features, as: :featurable
  has_many :features, through: :item_features

  validates :name, :description, presence: true
  
  enum status: { active: 1, inactive: 0 }
end
