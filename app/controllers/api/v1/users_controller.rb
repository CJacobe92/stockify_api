  require './lib/token_helper'
  require './lib/headers_helper'

  class Api::V1::UsersController < ApplicationController
    include TokenHelper
    include HeadersHelper
    skip_before_action :authenticate, only: [:create]
    before_action :authorized_admin, only: [:index, :destroy]
    before_action :find_user, only: [:show, :update]
    
    def index
      @users = User.includes(accounts: [:portfolios, :transactions])
      render 'index', status: :ok
    end

    def create
      @user = User.create(user_params)

      if @user.save
        UserMailer.welcome_email(@user).deliver_later
        token = encode_token(id: @user.id)
        @user.update(token: token)
        response_headers(@user, token)
        render 'create', status: :created
      else 
        render 'create', status: :unprocessable_entity
      end
    end

    def show
      if @current_user == @found_user
        render 'show', status: :ok
      elsif @current_admin
        @current_user = User.find(params[:id])
        render 'show', status: :ok
      else
        render json: {error: 'Unauthorized resource access'}, status: :unauthorized
      end
    end
    
    def update
      if @current_user == @found_user
        @current_user.update(user_params)
        render 'update', status: :ok
      elsif @current_admin
        @current_user = User.find(params[:id])
        @current_user.update(user_params)
        render 'update', status: :ok
      else
        render json: {error: 'Unauthorized resource access'}, status: :unauthorized
      end
    end

    def destroy
      @current_user = User.find(params[:id])
      return unless @current_user.destroy
      render json: 'User deleted', status: :no_content
    end

    private

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end

    def authorized_admin
      render json: {error: 'Unauthorized admin access'}, status: :unauthorized unless @current_admin
    end

    def find_user
      @found_user = User.find(params[:id])
    end
  end
