class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @user = User.new
    @provinces = Province.pluck(:name).sort
    super
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle successful registration
      redirect_to new_user_session_path, notice: 'Registration successful! Please login.'
    else
      # Handle registration errors
      @provinces = Province.pluck(:name).sort
      render :new
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :address, :province_id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :address, :province_id)
  end
end
