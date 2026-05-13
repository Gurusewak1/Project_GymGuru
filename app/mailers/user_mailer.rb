class UserMailer < ApplicationMailer
  def temp_password(user, temp_password)
    @user = user
    @temp_password = temp_password

    mail(
      to: @user.email,
      subject: "GymGuru Temporary Password"
    )
  end
end