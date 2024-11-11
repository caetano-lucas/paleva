class Order < ApplicationRecord
  belongs_to :restaurant
  validates :client_name, :restaurant, presence: true
  validate :phone_or_email_present

  private

  def phone_or_email_present
    if phone.blank? && email.blank?
      errors.add(:base, "Você deve fornecer pelo menos um contato: telefone ou e-mail.")
    end
  end
end