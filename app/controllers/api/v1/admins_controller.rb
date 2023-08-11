require './lib/token_helper'
require './lib/headers_helper'

class Api::V1::AdminsController < ApplicationController
  include TokenHelper
  include HeadersHelper

  def index
    @admins = Admin.all
    render 'index', status: :ok
  end

  def create
    @admin = Admin.create(admin_params)

    if @admin.save
      token = encode_token(id: @admin.id)
      response_headers(@admin, token)
      render 'create', status: :created
    else 
      render 'create', status: :unprocessable_entity
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
