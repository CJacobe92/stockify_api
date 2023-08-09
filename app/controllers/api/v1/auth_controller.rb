require './lib/token_helper'
require './lib/headers_helper'


class Api::V1::AuthController < ApplicationController
  include TokenHelper
  include HeadersHelper

  # creates the token
  def login
    email = params[:auth][:email]
    password = params[:auth][:password]

    user = User.find_by(email: email)
    admin = Administrator.find_by(email: email)

    if user&.authenticate(password) && user.activated
      handle_successful_login(user)
    elsif admin&.authenticate(password)
      handle_successful_login(admin)
    else
      handle_failed_login
    end
  end

  def password_reset
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_reset_token(user_id: user.id)
      user.update(reset_token: token)
      UserMailer.password_reset_email(user, token).deliver_later
      render json: {message: "Password reset email for #{user.email}"}, status: :ok
    else
      render json: {error: 'Password reset email sending failed'}, status: :internal_server_error
    end
  end

  def password_update
    token = params[:token]
    decoded_token = decode_token(token)
    user = User.find(decoded_token['user_id'])

    if user.reset_token === token && Time.now < Time.parse(decoded_token['expiry'])
      user.update(activated: true)
      render json: { message: "Account activated for #{user.email}" }, status: :ok
    else
      render json: { error: 'Activation expired. Please contact your administrator' }, status: :unprocessable_entity
    end 
  end

  def activation
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_activation_token(user_id: user.id)
      user.update(activation_token: token)
      UserMailer.activation_email(user, token).deliver_later  
      render json: {message: "Activation email sent for #{user.email}", token: token}, status: :ok
    else
      render json: {error: 'Activation email sending failed'}, status: :internal_server_error
    end
  end

  def activate
    token = params[:token]
    decoded_token = decode_token(token)
    user = User.find(decoded_token['user_id'])

    if user.activation_token === token && Time.now < Time.parse(decoded_token['expiry'])
      user.update(activated: true)
      render json: { message: "Account activated for #{user.email}" }, status: :ok
    else
      render json: { error: 'Activation expired. Please contact your administrator' }, status: :unprocessable_entity
    end 
  end

  def password_update
    token = params[:token]
    decoded_token = decode_token(token)
    user = User.find(decoded_token['user_id'])

    if user.reset_token === token && Time.now < Time.parse(decoded_token['expiry'])
      user.update(activated: true)
      render json: { message: "Account activated for #{user.email}" }, status: :ok
    else
      render json: { error: 'Activation expired. Please contact your administrator' }, status: :unprocessable_entity
    end 
  end

  def enable_otp
    user = User.find(params[:id])
    secret_key = ROTP::Base32.random
    user.update(otp_secret_key: secret_key)
    totp = ROTP::TOTP.new(issuer: 'Stockify')
    provisioning_uri = totp.provisioning_uri(user.email)
    qrcode = RQRCode::QRCode.new(provisioning_uri)
    svg = qrcode.as_svg(module_size: 4)
    svg_base64 = Base64.encode64(svg)

    render json: {
      url: provisioning_uri,
      secret_key: secret_key,
      qrcode: svg_base64
    }
  end

  def verify_otp
    user = User.find(params[:id])
    otp_code = params[:auth][:otp]

    if user
      totp = ROTP::TOTP.new(user.otp_secret_key, issuer: 'Stockify')
      if totp.verify(otp_code)
        # OTP code is valid
        token = encode_token(user_id: user.id)
        user.update(token: token, otp_enabled: true)
        response_headers(user, token)
        render json: { message: 'OTP code is valid' }, status: :ok
      else
        # OTP code is invalid
        render json: { error: 'Invalid OTP code'}, status: :unprocessable_entity
      end
    else
      render json: { error: 'User or OTP code not provided' }, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password, :otp)
  end

  def handle_successful_login(account)
    token = encode_token(user_id: account.id)
    account.update(token: token)
    response_headers(account, token)
    render json: {message: 'Login successful'}, status: :ok
  end

  def handle_failed_login
    render json: {error: 'Invalid login credentials or account is not yet activated'}, status: :unauthorized
  end

end
