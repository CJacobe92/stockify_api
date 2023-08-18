class Api::V1::TransactionsController < ApplicationController
  before_action :find_account, only: [:create]

  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def create

    @transaction = @current_account.transactions.create(transaction_params)
    
    if @transaction.save
      render json: { message: @transaction }, status: :created 
    else
      render json: {error: @transaction.errors.full_messages}, status: :unprocessable_entity
    end
  end
  
  private 

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :quantity).merge(stock_id: params[:stock_id])
  end

  def find_account
    @current_account = @current_user.accounts.find(params[:account_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end
end
