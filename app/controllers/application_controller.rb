class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart

  private

  def current_cart
    session[:cart] ||= {}
  end

  protected

  def after_sign_in_path_for(resource)
    # Customize this method to redirect to the desired path
    root_path # Example: Redirects to the root of your application
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation
                                               current_password])
  end
end
