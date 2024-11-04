class Drink < ApplicationRecord
  belongs_to :restaurant
  validates :name, :description, :restaurant_id, presence: true
  has_many :portions, as: :portionable, dependent: :destroy
  has_one_attached :image
  enum status: { active: 1, inactive: 0 }
end