# config/routes.rb
Rails.application.routes.draw do
  get 'orders/create'
  root to: 'pages#home'

  # Devise routes for users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, path: '', path_names: { sign_in: 'login', sign_up: 'register' }, skip: [:sessions]

  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'logout', to: 'devise/sessions#destroy', as: :logout
  end

  # Devise routes for admin users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Static pages routes
  get 'home', to: 'pages#home', as: :home
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact

  resources :products, only: [:index, :show] do
    member do
      get 'add_to_cart'
    end
  end

  resources :checkout, only: [:index] do
    post 'create_order', on: :collection
    patch 'update_province', on: :collection
  end
  
  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: 'add_to_cart'
    get 'remove/:product_id', to: 'carts#remove', as: 'remove_from_cart'
    patch 'update/:product_id', to: 'carts#update', as: 'update_cart'
  end

  resources :cart_items, only: [:destroy]

  resources :categories, only: [:index, :show]

  get 'up', to: 'rails/health#show', as: :rails_health_check
end
