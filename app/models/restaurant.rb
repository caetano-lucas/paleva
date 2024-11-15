class Restaurant < ApplicationRecord
  has_many :users
  has_many :dishes
  has_many :drinks
  has_many :operating_hours, dependent: :destroy
  has_many :features
  has_many :menus
  has_many :orders
    
  validates :trade_name, :legal_name, :cnpj, :address, :phone, :email, :alphanumeric_code, presence: true
  validates :legal_name, :cnpj, :address, :phone, :email, :alphanumeric_code, uniqueness: true
  validates :cnpj, cnpj: true
  validates :email,
	  format: { with: /\A(.+)@(.+)\z/, message: "Email invalid"  },
            uniqueness: { case_sensitive: false },
            length: { minimum: 4, maximum: 254 }
  validates :phone, length: { minimum: 10, maximum: 11 }

  before_validation :generate_code

  private

  def generate_code
    self.alphanumeric_code = SecureRandom.base36(6)
  end
end