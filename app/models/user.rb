class User < ApplicationRecord
  belongs_to :restaurant, optional: true
  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, cpf: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
