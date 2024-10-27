Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'home#index'
  resources :restaurants
  
  resources :restaurant do
    resources :dishes
  end

  resources :restaurant do
    resources :drinks
  end
end
