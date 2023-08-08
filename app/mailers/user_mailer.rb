class UserMailer < ApplicationMailer
  default from: 'cjacobedev92mailer@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Stockify')
  end

  def password_reset_email(user, token)
    @user = user
    @password_reset_url = "#{Rails.application.credentials.activation[:URL]}/api/v1/auth/activation?token=#{token}"
    mail(to: @user.email, subject: 'Reset your Stockify Password')
  end

  def activation_email(user, token)
    @user = user
    @activation_url= "#{Rails.application.credentials.password_reset[:URL]}/api/v1/auth/reset?token=#{token}"
    mail(to: @user.email, subject: 'Stockify account activation')
  end
end
