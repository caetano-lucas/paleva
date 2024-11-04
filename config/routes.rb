Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'home#index'
  resources :restaurants
    
  resources :restaurant do
    resources :dishes do
      get 'search', on: :collection
      post 'change_status', on: :member
      resources :dish_features, only: [:new, :create]

       resources :portions, controller: 'portions', type: 'Dish'
    end

    resources :drinks do
      get 'search', on: :collection
      post 'change_status', on: :member

       resources :portions, controller: 'portions', type: 'Drink'
    end

    resources :operating_hours
    
    resources :features
    
  end
end
