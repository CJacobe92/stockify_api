require './lib/portfolio_updater'

class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate
  before_action :find_account, only: [:create]

  def create
    begin
      @transaction = @current_account.transactions.new(transaction_params)
      
      if @transaction.save
        render json: { message: @transaction }, status: :created 
      else
        render json: { error: @transaction.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  
  private 

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :quantity).merge(stock_id: params[:stock_id])
  end

  def find_account
    @current_account = @current_user.accounts.find(params[:account_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Account not found' }, status: :not_found
  end
end
