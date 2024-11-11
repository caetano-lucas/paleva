class Drink < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image
  has_many :portions, as: :portionable, dependent: :destroy

  has_many :item_features, as: :featurable
  has_many :features, through: :item_features

  has_many :menu_items, as: :menu_itemable
  has_many :menus, through: :menu_items

  validates :name, :description, :restaurant_id, presence: true
  
  enum status: { active: 1, inactive: 0 }
end
