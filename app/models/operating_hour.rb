class OperatingHour < ApplicationRecord
  belongs_to :restaurant

  validates :day, presence: true, inclusion: { in: %w[segunda-feira terça-feira quarta-feira quinta-feira sexta-feira sábado domingo] }
  validates :open_time, :close_time, presence: true
  validate :close_time_more_than_open_time

  private

  def close_time_more_than_open_time
    if close_time <= open_time
      flash.now[ :notice] = "Horario de fechamento deve ser maior que o horário de abertura"
    end
  end
end