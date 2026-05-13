class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      temp_pass = SecureRandom.alphanumeric(10)

      user.password = temp_pass
      user.password_confirmation = temp_pass
      user.save!

      UserMailer.temp_password(user, temp_pass).deliver_now
    end

    redirect_to new_user_session_path,
      notice: "Temporary password sent to your email."
  end
end