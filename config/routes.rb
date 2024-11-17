Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'home#index'

  resources :restaurants do
    resources :dishes do
      get 'search', on: :collection
      post 'change_status', on: :member
      resources :features, only: [:new, :create]
      resources :menus, only: [:new, :create]

      resources :portions, controller: 'portions', type: 'Dish'
    end

    resources :drinks do
      get 'search', on: :collection
      post 'change_status', on: :member
      resources :features, only: [:new, :create]
      resources :menus, only: [:new, :create]
      resources :portions, controller: 'portions', type: 'Drink'
    end

    resources :operating_hours
    resources :employees, only: [:new, :index, :create]
    resources :features
    resources :menus
    resources :orders
  end

  namespace :api do
    namespace :v1 do
        get 'restaurants/:restaurant_alphanumeric_code/orders/:order_alphanumeric_code', to: 'orders#show', as: 'show'
        patch 'restaurants/:restaurant_alphanumeric_code/orders/:order_alphanumeric_code', to: 'orders#update', as: 'update'
        get 'restaurants/:restaurant_alphanumeric_code/orders/', to: 'orders#index', as: 'index'
    end
  end
end