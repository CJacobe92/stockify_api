require './lib/token_helper'
require './lib/headers_helper'


class Api::V1::AuthController < ApplicationController
  include TokenHelper
  include HeadersHelper

  # creates the token
  def login
    user = User.find_by(email: params[:auth][:email])

    if user && user.authenticate(params[:auth][:password])
      token = encode_token(user_id: user.id)
      user.update(token: token)
      response_headers(user, token)
      render json: { message: 'Login successful' } , status: :ok
    else
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  def password_reset
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_reset_token(user_id: user.id)
      user.update(reset_token: token)
      UserMailer.password_reset_email(user, token).deliver_now
      render json: {message: "Password reset email for #{user.email}"}, status: :ok
    else
      render json: {error: 'Password reset email sending failed'}, status: :internal_server_error
    end
  end

  def password_update
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_reset_token(user_id: user.id)
      user.update(reset_token: token)
      UserMailer.password_reset_email(user, token).deliver_now
      render json: {message: "Password reset email for #{user.email}"}, status: :ok
    else
      render json: {error: 'Password reset email sending failed'}, status: :internal_server_error
    end
  end

  def activation
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_activation_token(user_id: user.id)
      user.update(activation_token: token)
      UserMailer.activation_email(user, token).deliver_now
      render json: {message: "Activation email sent for #{@user.email}"}, status: :ok
    else
      render json: {error: 'Activation email sending failed'}, status: :internal_server_error
    end
  end

  def activate
    token = params[:token]
    decoded_token = decode_token(token)
    user = User.find(decoded_token['id'])

    if user.activation_token === token && Time.now < Time.parse(decoded_token['expiry'])
      user.update(activated: true)
      render json: { message: "Account activated for #{user.email}" }, status: :ok
    else
      render json: { error: 'Activation expired. Please contact your administrator' }, status: :unprocessable_entity
    end 
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

end
