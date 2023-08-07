class Api::V1::UsersController < ApplicationController

  before_action :set_user, except: [:index, :create]

  def index
    @users = User.all
    render 'index', status: :ok
  end

  def create
    @user = User.create(user_params)

    if @user.save
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
    render json: 'User deleted', status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end

  def set_user
    @current_user ||= User.find(params[:id])
  end
end
