Rails.application.routes.draw do
  # Routes for carts
  get 'carts/show'
  get 'carts/add'
  get 'carts/remove'
  get 'carts/update'

  # Root route
  root to: 'pages#home'

  # Example of typical Devise routes with skipping destroy session route
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

  # Resources routes
  resources :products, only: [:index, :show] do
    post 'add_to_cart', on: :member
  end

  resources :categories, only: [:index, :show]

  # Cart resource routes
  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: 'add_to_cart'
    delete 'remove/:product_id', to: 'carts#remove', as: 'remove_from_cart'
    patch 'update/:product_id', to: 'carts#update', as: 'update_cart'
  end

  # Static pages routes
  get 'home', to: 'pages#home', as: :home
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact

  # Health check route (example)
  get 'up', to: 'rails/health#show', as: :rails_health_check
end
