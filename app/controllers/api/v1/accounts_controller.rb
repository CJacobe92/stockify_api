class Api::V1::AccountsController < ApplicationController
  # before_action :set_account

  # def update
  #   update_account
  #   render 'update', status: :ok
  # end

  # private

  # def account_params
  #   params.require(:account).permit(:name, :balance)
  # end

  # def set_account
  #   if @current_admin
  #     @current_account = Account.find(params[:id])
  #   else
  #     @current_account = @current_user.accounts.find(params[:id])
  #   end
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Account not found' }, status: :not_found
  # end

  # def update_account
  #   @current_account.update(account_params)
  # end
end
