require 'rails_helper'

describe 'Usuario acessa homepage' do
  it 'com sucesso' do
    visit root_path
    click_on 'Palevá'

    expect(current_path).to eq root_path
  end
end