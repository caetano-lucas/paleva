class OrderItem < ApplicationRecord
  belongs_to :portion
  belongs_to :order
end
