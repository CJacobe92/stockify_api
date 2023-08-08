require './lib/token_helper'
require './lib/headers_helper'

class Api::V1::UsersController < ApplicationController
  include TokenHelper
  include HeadersHelper

  def index
    @users = User.all
    render 'index', status: :ok
  end

  def create
    @user = User.create(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      token = encode_token(user_id: @user.id)
      response_headers(@user, token)
      render 'create', status: :created
    else 
      render 'create', status: :unprocessable_entity
    end

  end

  def show
    @current_user
    render 'show', status: :ok
  end

  
  def update
    return unless @current_user.update(user_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_user.destroy
    render json: 'User deleted', status: :no_content
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end
