require 'rails_helper'

describe 'Usuario acessa homepage' do
  it 'com sucesso' do
    visit root_path
    within('nav') do
      click_on 'PaLevá'
    end

    expect(current_path).to eq new_user_session_path
  end
end
