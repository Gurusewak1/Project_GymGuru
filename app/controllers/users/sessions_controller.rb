# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  # POST /login
  def create
    Rails.logger.debug "Attempting to authenticate user with email: #{params[:user][:email]}"
    self.resource = warden.authenticate!(auth_options)
    if resource.nil?
      Rails.logger.debug "Authentication failed for email: #{params[:user][:email]}"
      flash[:alert] = "Invalid email or password."
      redirect_to new_user_session_path
    else
      Rails.logger.debug "Authentication succeeded for email: #{params[:user][:email]}"
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  rescue StandardError => e
    Rails.logger.error "Error during authentication: #{e.message}"
    flash[:alert] = "An error occurred. Please try again."
    redirect_to new_user_session_path
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end
  

  protected

  def after_sign_in_path_for(resource)
    # Customize the redirect after sign-in
    # For example, you can redirect to the user's profile page:
    # user_path(resource)
    root_path
  end
end
