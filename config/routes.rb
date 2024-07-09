Rails.application.routes.draw do
  # Devise routes for users with custom registrations controller
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'

  }, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  # Devise routes for admin users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Products routes
  resources :products, only: [:index, :show]

  # Static pages routes
  get 'home', to: 'pages#home', as: :home
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact

  # Root route
  root to: 'pages#home'

  # Health check route (example)
  get 'up', to: 'rails/health#show', as: :rails_health_check
end

