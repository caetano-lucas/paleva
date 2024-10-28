Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'home#index'
  resources :restaurants
    
  resources :restaurant do
    resources :dishes do
      get 'search', on: :collection
    end
  end

  resources :restaurant do
    resources :drinks do
      get 'search', on: :collection
    end
  end
  resources :restaurants do
    resources :operating_hours
  end
end
