require './lib/token_helper'
require './lib/headers_helper'

class Api::V1::AuthController < ApplicationController
  include TokenHelper
  include HeadersHelper
  skip_before_action :authenticate, only: [:login, :password_reset, :password_update, :activate]

  # creates the token
  def login
    email = params[:auth][:email]
    password = params[:auth][:password]

    user = User.find_by(email: email)
    admin = Admin.find_by(email: email)

    if user&.authenticate(password)
      if user.activated? && user.otp_enabled? 
          handle_successful_login(user)
      elsif 
          handle_successful_login(user)
      end
    elsif admin&.authenticate(password)
      handle_successful_login(admin)
    else
      handle_failed_login
    end
  end

  def logout
    user = User.find(params[:id])
    
    user.update(token: nil, otp_required: true)

    render json: {message: 'Logout successful'}, status: :ok
  end

  def password_reset
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_reset_token(id: user.id)
      user.update(reset_token: token)
      UserMailer.password_reset_email(user, token).deliver_later
      render json: {message: "Password reset email for #{user.email}", token: token}, status: :ok
    else
      render json: {error: 'Email not found'}, status: :not_found
    end
  end

  def password_update
    token = params[:token]
    decoded_token = decode_token(token)
    user = User.find(decoded_token['id'])

    if user.reset_token === token && Time.now < Time.parse(decoded_token['expiry'])
      user.update(password: params[:auth][:password], password_confirmation: params[:auth][:password_confirmation], reset_token: nil, token: nil)
      render json: { message: "Password updated for #{user.email}" }, status: :ok
    else
      render json: { error: 'Unauthorized password update' }, status: :unauthorized
    end 
  end

  def activation
    user = User.find_by(email: params[:auth][:email])

    if user
      token = encode_activation_token(id: user.id)
      user.update(activation_token: token)
      UserMailer.activation_email(user, token).deliver_later  
      render json: {message: "Activation email sent for #{user.email}", token: token}, status: :ok
    else
      render json: {error: 'Email not found'}, status: :not_found
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
      render json: { error: 'Activation expired. Please contact your administrator' }, status: :unauthorized
    end 
  end

  def configure_otp
    user = User.find(params[:id])

    if user.otp_enabled? 
      render json: {error: '2FA already registered'}, status: :unauthorized
    else
      secret_key = ROTP::Base32.random
      user.update(otp_secret_key: secret_key)

      totp = ROTP::TOTP.new(secret_key, issuer: 'Stockify')
      provisioning_uri = totp.provisioning_uri(user.email)
      qrcode = RQRCode::QRCode.new(provisioning_uri)
      svg = qrcode.as_svg(module_size: 12)
      svg_base64 = Base64.encode64(svg)

      render json: {
        provisioning_uri: provisioning_uri,
        qrcode: svg_base64,
        key: secret_key
      }, status: :ok
    end
  end

  def enable_otp
    user = User.find(params[:id])
    otp_code = params[:auth][:otp]
    totp = ROTP::TOTP.new(user.otp_secret_key, issuer: 'Stockify')
    
    if totp.verify(otp_code)
      # OTP code is valid
      token = encode_token(id: user.id)
      user.update(token: token, otp_enabled: true, otp_required: false)
      response_headers(user, token)
      render json: { message: 'OTP code is valid' }, status: :ok
    else
      # OTP code is invalid
      render json: { error: 'Invalid OTP code'}, status: :unprocessable_entity
    end
  end

  def verify_otp
    user = User.find(params[:id])
    otp_code = params[:auth][:otp]
    totp = ROTP::TOTP.new(user.otp_secret_key, issuer: 'Stockify')
    
    if totp.verify(otp_code)
      # OTP code is valid
      token = encode_token(id: user.id)
      user.update(token: token, otp_required: false)
      response_headers(user, token)
      render json: { message: 'OTP code is valid' }, status: :ok
    else
      # OTP code is invalid
      render json: { error: 'Invalid OTP code'}, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password, :otp)
  end

  def handle_successful_login(account)
    token = encode_token(id: account.id)
    account.update(token: token)
    response_headers(account, token)
    render json: {message: 'Login successful'}, status: :ok
  end

  def handle_failed_login
    render json: {error: 'Invalid login credentials or account is not yet activated'}, status: :unauthorized
  end

end
