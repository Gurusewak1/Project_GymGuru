# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: [:create]

    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      end
  
    protected
  
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute_to_permit])
    end
  end
  