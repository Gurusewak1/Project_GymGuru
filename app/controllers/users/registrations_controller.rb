class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @provinces = Province.pluck(:id, :name).sort_by { |_, name| name }
    super
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle successful registration
      redirect_to new_user_session_path, notice: "Registration successful! Please login."
    else
      # Handle registration errors
      @provinces = Province.pluck(:id, :name).sort_by { |_, name| name }
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @orders = @user.orders # Assuming `User` has_many `Order`s association
    # Additional logic if needed
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[name email password password_confirmation
                                               address province_id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :address,
                                 :province_id)
  end
end
