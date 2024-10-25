class Restaurant < ApplicationRecord  
  validates :trade_name, :legal_name, :cnpj, :address, :phone, :email, presence: true
  validates :legal_name, :cnpj, :address, :phone, :email, uniqueness: true
  validates :cnpj, cnpj: true
end
