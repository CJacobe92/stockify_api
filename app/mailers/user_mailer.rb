class UserMailer < ApplicationMailer
  default from: 'cjacobedev92mailer@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Stockify')
  end

  def password_reset_email(user, token)
    @user = user
    @password_update_url = "#{Rails.application.credentials.password_update[:URL]}/api/v1/auth/password_update?token=#{token}"
    mail(to: @user.email, subject: 'Reset your Stockify Password')
  end

  def activation_email(user, token)
    @user = user
    @activation_url= "#{Rails.application.credentials.activation[:URL]}/api/v1/auth/activate?token=#{token}"
    mail(to: @user.email, subject: 'Stockify account activation')
  end
end
