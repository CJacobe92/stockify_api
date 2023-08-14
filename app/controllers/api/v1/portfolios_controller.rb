class Api::V1::PortfoliosController < ApplicationController
  before_action :set_portfolio

  def update
    update_portfolio
    render 'update', status: :ok
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:shares, :unrealized_pl, :equity).merge(stock_id: params[:stock_id])
  end

  def set_portfolio
    if @current_admin
      @current_portfolio = Portfolio.find(params[:id])
    else
      @current_account = @current_user.accounts.find(params[:id])
      @current_portfolio = @current_account.portfolios.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Account not found' }, status: :not_found
  end

  def update_portfolio
    @current_portfolio.update(portfolio_params)
  end
end
