Rails.application.routes.draw do
  get 'plans/show'
  root to: 'pages#home'

  # Static pages routes
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact

  # Products routes
  resources :products, only: [:index, :show] do
    member do
      get 'add_to_cart'
    end
  end

  # Cart routes
  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: 'add_to_cart'
    get 'remove/:product_id', to: 'carts#remove', as: 'remove_from_cart'
    patch 'update/:product_id', to: 'carts#update', as: 'update_cart'
  end

  # Checkout routes
  resources :checkout, only: [:index] do
    collection do
      post 'create_order'
      patch 'update_province'
      post 'create_payment'
      get 'create_payment'
      get 'success', to: 'checkout#success', as: 'checkout_success'
      get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    end
  end

  # Categories routes
  resources :categories, only: [:index, :show]

  # Health check route
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Devise routes for users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, path: '', path_names: { sign_in: 'login', sign_up: 'register' }, skip: [:sessions]

  # Custom routes for user sessions
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'logout', to: 'devise/sessions#destroy', as: :logout
  end
  resources :orders, only: [:show, :index]  # Example route for order details

  resources :plans, only: [:new, :create, :show]

  get '/plans', to: 'plans#index'  
  get 'plans/new', to: 'plans#new'
  post 'plans', to: 'plans#create'
  get 'plans/show', to: 'plans#show'

  # Devise routes for admin users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
