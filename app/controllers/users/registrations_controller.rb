class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
  
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
      if @user.save
        # Handle successful registration
        redirect_to root_path, notice: 'Registration successful!'
      else
        # Handle registration errors
        render :new
      end
    end
  
    private
  
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name])  # Ensure 'name' is permitted
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  