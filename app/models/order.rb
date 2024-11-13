class Order < ApplicationRecord
  belongs_to :restaurant
  validates :client_name, :restaurant, :alphanumeric_code, presence: true
  validates :email,
             format: { with: /\A(.+)@(.+)\z/, message: "Email invalid"  }, allow_blank: true
  validates :phone, length: { minimum: 10, maximum: 11 }, allow_blank:  true
  validate :phone_or_email_present
  has_many :order_items
  has_many :portions, through: :order_items

  before_validation :generate_code

  enum status: { aguardando_confirmacao_cozinha: 0, cancelado: 1, preparação: 2, pronto: 3, entregue: 4 }

  private

  def phone_or_email_present
    if phone.blank? && email.blank?
      errors.add(:base, "Você deve fornecer pelo menos um contato: telefone ou e-mail.")
    end
  end

  def generate_code
    self.alphanumeric_code = SecureRandom.base36(8)
  end
end