class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
    def after_sign_in_path_for(resource)
        # Customize this method to redirect to the desired path
        root_path  # Example: Redirects to the root of your application
      end
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
      devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password])
    end
  end
  