class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true
end
