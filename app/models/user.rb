class User < ApplicationRecord
  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
