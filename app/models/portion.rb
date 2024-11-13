class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true

  has_many :order_items
  has_many :orders, through: :order_items
end
