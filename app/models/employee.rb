class Employee < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  validates :email, :cpf, presence: true
  validates :cpf, uniqueness: true
end