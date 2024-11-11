class MenuItem < ApplicationRecord
  belongs_to :menu_itemable, polymorphic: true
  belongs_to :menu
end
