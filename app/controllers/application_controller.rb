require './lib/token_helper'

class ApplicationController < ActionController::API
  include TokenHelper
  before_action :authenticate, except: [:create, :login, :activate, :password_reset, :password_update]

  def authenticate
    header = request.headers['Authorization']

    if header.blank?
      render json: { error: 'Auth header missing'}, status: :unauthorized
      return
    end
    
    begin
      sanitized_header = header.split(' ').last
      data = decode_token(sanitized_header)
      expiry = data['expiry']
      id = data['user_id']
    
      if data && expiry <= Time.now
        render json: { error: 'Token expired'}, status: :unauthorized
        return
      end
      
      verified_user = User.find(id)
      verified_admin = Administrator.find(id)

      # Ensures that the token being verified again is the same with the token issue and listed on the records. 
      # Preventing double sign in

      if verified_user && verified_user.token == sanitized_header
        @current_user = verified_user
      elsif verified_admin && verified_admin.token == sanitized_header
        @current_admin = verified_admin
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized    
    end
  end

end
