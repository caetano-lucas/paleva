require 'rails_helper'

describe 'Usuario acessa homepage' do
  it 'se estiver autenticado' do 
    
    visit root_path

    expect(current_path).not_to have_link 'Bebidas Cadastradas'
    expect(current_path).not_to have_link 'Pratos Cadastrados'
    
  end
  it 'e é redirecionado' do
    visit root_path
    within('nav') do
      click_on 'PaLevá'
    end

    expect(current_path).to eq new_user_session_path
  end
end
