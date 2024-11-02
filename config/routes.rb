Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'home#index'
  resources :restaurants
    
  resources :restaurant do
    resources :dishes do
      get 'search', on: :collection
    end

    resources :drinks do
      get 'search', on: :collection
    end

    resources :operating_hours
  end
end
