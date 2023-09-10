require './lib/token_helper'
require './lib/headers_helper'

class Api::V1::AdminsController < ApplicationController
  include TokenHelper
  include HeadersHelper
  
  before_action :authenticate

  def index
    @admins = Admin.all
    render 'index', status: :ok
  end

  def create
    if @current_admin
      @admin = Admin.new(admin_params)
      
      if @admin.save 
        @admin.update(activated: true)
        render 'create', status: :created
      else
        render json: { error: 'Failed to create admin', errors: @admin.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  def show
    @current_admin
    render 'show', status: :ok
  end

  def update
    return unless @current_admin.update(admin_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_admin.destroy
    render json: 'administrator deleted', status: :no_content
  end

  private

  def admin_params
    params.require(:admin).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end

end
