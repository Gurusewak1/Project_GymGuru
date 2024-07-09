class ApplicationController < ActionController::Base
    before_action :authenticate_user!
  protect_from_forgery with: :exception

  # Include Devise helper methods
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

end
