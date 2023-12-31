class UserMailer < ApplicationMailer
  default from: 'cjacobe.dev92@hotmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Stockify')
  end

  def password_reset_email(user, token)
    @user = user
    @password_update_url = "#{Rails.application.credentials.mailer_url[:password_update]}/api/v1/auth/password_update?token=#{token}"
    mail(to: @user.email, subject: 'Reset your Stockify Password')
  end

  def activation_email(user, token)
    @user = user
    @activation_url= "#{Rails.application.credentials.mailer_url[:activation]}/api/v1/auth/activate?token=#{token}"
    mail(to: @user.email, subject: 'Stockify account activation')
  end
end
