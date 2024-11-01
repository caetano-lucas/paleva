require 'rails_helper'

RSpec.describe OperatingHour, type: :model do
  describe '#valid?' do 
    it 'dia da semana deve ser obrigatorio' do
      operating_hour = OperatingHour.new(day: '', open_time: '2000-01-01 20:00:00.000000000 +0000', close_time: '2000-01-01 20:14:00.000000000')

      operating_hour.valid?

      expect(operating_hour.errors.include? :day).to eq true
    end
  end
end