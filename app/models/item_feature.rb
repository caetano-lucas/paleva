class ItemFeature < ApplicationRecord
  belongs_to :featurable, polymorphic: true
  belongs_to :feature
end
